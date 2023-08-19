local sidebar = require("sidebar-nvim")

BufferInfo = {
  buffers = {},
  buffer_handle_to_name = {},
  buf_handles = {},
  diagnostics_called = 0,
  last_run = os.time(),
  cached_ls_text = '',
}

function buf_handles_changed(buf_handles)
  if #BufferInfo.buf_handles ~= #buf_handles then
    return true
  end

  local i_cache, val_cache = next(BufferInfo.buf_handles, nil)
  local i_cur, val_cur = next(buf_handles, nil)
  while i_cache and i_cur do
    if val_cache ~= val_cur then
      return true
    end
    i_cache, val_cache = next(BufferInfo.buf_handles, i_cache)
    i_cur, val_cur = next(buf_handles, i_cur)
  end
  return false
end

local sep = "/"
if vim.fn.has('windows') then
  sep = "\\"
end

-- TODO: Do a bit more clever logic to find unique path parts and prioritize
-- project location. E.g. instead of taking the last n parts, start with first
-- ones out of project root
function add_friendly_names(buffers)
  for _, buffer in pairs(buffers) do
    buffer["name_parts"] = vim.split(buffer["name"], "[\\/]")
  end

  local num_overlaps = 0
  local name_attempts = {}
  -- Rough algorithm:
  -- - Produce the easiest name for each file
  -- - If any files have overlaps, produce alternatives for those files
  -- - Repeat with successively longer alternatives until no overlaps
  -- - We know this terminates since file names are unique
  -- - Can keep adding to name_attempts - that way if a lengthening of one file
  --  overlaps with a *different* file we still capture and fix
  for _, buffer in pairs(buffers) do
    local index = #buffer["name_parts"]
    local proposed_name = buffer["name_parts"][index]
    buffer["proposed_name"] = proposed_name
    buffer["last_name_part"] = index
    if name_attempts[proposed_name] == nil then
      name_attempts[proposed_name] = 1
    else
      name_attempts[proposed_name] = name_attempts[proposed_name] + 1
      num_overlaps = num_overlaps + 1
    end
  end
  while (num_overlaps > 0) do
    num_overlaps = 0
    for _, buffer in pairs(buffers) do
      local proposed_name = buffer["proposed_name"]
      if name_attempts[proposed_name] ~= nil and name_attempts[proposed_name] > 1 then
        local last_name_part = buffer["last_name_part"] - 1
        buffer["proposed_name"] = buffer["name_parts"][last_name_part] .. sep .. proposed_name
        buffer["last_name_part"] = last_name_part
        if name_attempts[proposed_name] == nil then
          name_attempts[proposed_name] = 1
        else
          name_attempts[proposed_name] = name_attempts[proposed_name] + 1
          num_overlaps = num_overlaps + 1
        end
      end
    end
  end

  for _, buffer in pairs(buffers) do
    buffer["friendly_name"] = buffer["proposed_name"]
    -- TODO: Delete unneeded fields
  end

  return buffers
end

function split_to_array(str, pattern)
  local result = {}
  for part in string.gmatch(str, pattern) do
    table.insert(result, part)
  end
  return result
end

function add_buf_indicators(buf_info, match_str)
  local attrs = {
    current = false,
    active = false,
    hidden = false,
    readonly = false,
    modified = false,
  }
  -- TODO: Consider more traits
  for char in match_str:gmatch(".") do
    -- TODO: Slightly cheating without considering the position, but
    -- each option is an unique char, so it should be ok
    if char == '%' then
      attrs['current'] = true
    elseif char == 'a' then
      attrs['active'] = true
    elseif char == 'h' then
      attrs['hidden'] = true
    elseif char == '-' or char == '=' then
      attrs['readonly'] = true
    elseif char == '+' then
      attrs['modified'] = true
    end
  end

  for key, value in pairs(attrs) do
    buf_info[key] = value
  end
end

function get_extra_info(buf_handles)
  local extra_info = {}

  -- for _, buf_handle in ipairs(buf_handles) do
  --   local item = {}
  --   item['modified'] = vim.api.nvim_buf_get_option(buf_handle, 'modified')
  --   extra_info[buf_handle] = item
  -- end

  -- Oddly, :ls sometimes returns an empty string, happens consistently while
  -- refreshing just after a new buffer is spawned, cache it
  -- TODO: Cache the output instead so we can avoid parsing everything
  local ls_text = vim.api.nvim_exec(":ls", true)
  -- local ls_text = vim.cmd.ls()
  if ls_text == nil or ls_text == '' then
    ls_text = BufferInfo.cached_ls_text
  else
    BufferInfo.cached_ls_text = ls_text
  end
  for line in string.gmatch(ls_text, "[^\r\n]+") do
    _, _, buf_handle_str, match_str, file_name, line_str = string.find(
      line,
      -- TODO: Non-greedy match for .- may not work well, needs debugging
      -- Note: If we use ls!, there can be no spaces between the line and the
      -- letters
      "^%s*(%d+)%s+(.-)%s+\"(.*)\"%s+line (%d+)%s*$"
    )
    local buf_handle = tonumber(buf_handle_str)
    local line_number = tonumber(line_str)
    assert(buf_handle ~= nil)
    local buf_info = {
      buf_handle = buf_handle,
      file_name = file_name,
      line = line_number,
      tmp = match_str
    }
    add_buf_indicators(buf_info, match_str)
    extra_info[buf_handle] = buf_info
  end

  return extra_info
end

function get_buffers(options)
  local buffers = {}
  local vim_fn = vim.fn
  local api = vim.api

  -- Can also just do nvim_buf_get_name(0) - 0 acts as current
  local cur_buf_handle = api.nvim_get_current_buf()

  -- bufwinnr() checks if visible - -1 if not

  -- Memoize - only do the rest of the work if needed
  local buf_handles = {}
  for _, buf_handle in pairs(api.nvim_list_bufs()) do
    if api.nvim_buf_is_loaded(buf_handle) and vim_fn.buflisted(buf_handle) == 1 then
      table.insert(buf_handles, buf_handle)
    end
  end

  local extra_info = get_extra_info(buf_handles)

  -- ~TODO: Maybe impossible to cache this - need to determine active
  -- ~For now, just debounce (don't call more than once every 2s)
  -- if BufferInfo.last_run + 1 >= os.time() then
  -- end
  if not buf_handles_changed(buf_handles) then
    -- Still need to mark active and do other work - just don't recompute the
    -- names or handles
    buffers = BufferInfo.buffers
    for _, buf_info in pairs(buffers) do
      buf_info["active"] = buf_info.handle == cur_buf_handle
      local extra_info_buf = extra_info[buf_info.handle]
      if extra_info_buf ~= nil then
        for key, value in pairs(extra_info_buf) do
          buf_info[key] = value
        end
      end
    end
    BufferInfo.buffers = buffers
    return buffers
  end

  BufferInfo.buf_handles = buf_handles

  -- local extra_info = get_extra_info(buf_handles)

  for _, buf_handle in pairs(buf_handles) do
    local buf_info = {
      handle = buf_handle,
      name = api.nvim_buf_get_name(buf_handle),
      active = buf_handle == cur_buf_handle,
    }
    local extra_info_buf = extra_info[buf_handle]
    if extra_info_buf ~= nil then
      for key, value in pairs(extra_info_buf) do
        buf_info[key] = value
      end
    end
    table.insert(buffers, buf_info)
  end

  buffers = add_friendly_names(buffers)

  BufferInfo.buffers = buffers

  return buffers
end

function get_buffer_display_old(buffer_info)
  local prefix = ''
  if buffer_info.current then
    prefix = prefix .. '* '
  end
  if buffer_info.active then
    prefix = prefix .. 'v '
  end
  if buffer_info.modified then
    prefix = prefix .. '+ '
  end
  local name = buffer_info.friendly_name
  return prefix .. name
end

function get_buffer_display(buffer_info)
  local hl = "SidebarBufferNormal"
  local prefix = ''
  local suffix = ''
  if buffer_info.current then
    hl = "SidebarBufferCurrent"
    prefix = prefix .. '* '
  elseif buffer_info.active then
    hl = "SidebarBufferActive"
  end
  if buffer_info.modified then
    suffix = suffix .. ' +'
  end
  local name = buffer_info.friendly_name
  return prefix .. name .. suffix, hl
end

function get_buffer_string_old(options)
  local buffers = get_buffers(options)
  local parts = {}
  for _, buffer_info in pairs(buffers) do
    local buffer_display = get_buffer_display(buffer_info)
    -- table.insert(parts, buffer_info.handle .. ": " .. buffer_info.name)
    table.insert(parts, buffer_display)
  end
  return table.concat(parts, "\n")
end

function get_buffer_string(options)
  local buffers = get_buffers(options)
  local lines = {}
  local hls = {}
  for _, buffer_info in pairs(buffers) do
    local line, hl = get_buffer_display(buffer_info)
    table.insert(hls, {hl, #lines, 0, -1})
    table.insert(lines, line)
  end
  return {lines = lines, hl = hls}
end

function activate_buffer(index)
  vim.api.nvim_set_current_buf(BufferInfo.buffers[index + 1].handle)
end

-- Create autocommands to update
local autocmd = vim.api.nvim_create_autocmd
autocmd('BufEnter', {
  pattern = '',
  callback = function () sidebar.update() end,
})

-- vim.api.nvim_set_hl(0, 'SidebarBufferNormal', {fg="#FF0000"})
-- vim.api.nvim_set_hl(0, 'SidebarBufferCurrent', {fg="#00FF00"})
-- vim.api.nvim_set_hl(0, 'SidebarBufferActive', {fg="#0000FF"})

local buffers = {
  title = "Buffers",
  icon = ">",
  setup = function(ctx)
      -- called only once and if the section is being used
  end,
  update = function(ctx)
      -- hook callback, called when an update was requested by either the user of external events (using autocommands)
  end,
  draw = function(ctx)
    return get_buffer_string({})
  end,
  highlights = {
    groups = {
      -- Properties: gui, fg, bg
      -- SidebarBufferNormal = { gui='NONE' },
      -- SidebarBufferCurrent = { fg="#00FF00" },
      -- SidebarBufferActive = { fg="#0000FF" },
    },
    links = {
      SidebarBufferNormal = "SidebarNvimNormal",
      SidebarBufferActive = "SidebarNvimKeyword",
      SidebarBufferCurrent = "SidebarNvimLabel",
    },
  },
  bindings = {
    ['<CR>'] = function(line, col)
      return activate_buffer(line)
    end,
  }
}
local opts = {
  open = true,
  initial_width = 35,
  -- bindings = {
  --   ['<F4>'] = function() require('sidebar-nvim').toggle() end,
  -- },
  sections = {
    buffers,
    'git',
    -- 'diagnostics',
  },
}
sidebar.setup(opts)

local M = {}

function M.next_buf()
  return M.cycle_bufs(1)
end

function M.prev_buf()
  return M.cycle_bufs(-1)
end

function M.cycle_bufs(delta)
  assert(delta == 1 or delta == -1)

  -- TODO: Persist buffer order instead of using nvim order
  -- In case we don't have a buffers list yet, or failed to find the result, use
  -- regular :bnext / :bprevious
  local cur_buf_handle = vim.api.nvim_get_current_buf()
  local target_index = nil
  for index, buffer in pairs(BufferInfo.buffers) do
    if buffer.handle == cur_buf_handle then
      target_index = index + delta
      break
    end
  end

  if target_index ~= nil then
    -- Lua tables are 1-indexed
    target_index = (target_index - 1) % #BufferInfo.buffers + 1
    vim.api.nvim_set_current_buf(BufferInfo.buffers[target_index].handle)
  elseif delta == 1 then
    vim.cmd([[:bnext]])
  elseif delta == -1 then
    vim.cmd([[:bprevious]])
  else
    assert(false, "Unexpected state")
  end
end

function M.delete_buf()
  -- TODO: :bd removes the window with the buffer in it - resulting in e.g. the
  -- process being closed if there's only one buffer
  -- The fix here is to switch to another buffer, then delete the buffer
  -- https://vim.fandom.com/wiki/Deleting_a_buffer_without_closing_the_window
  if #BufferInfo.buf_handles <= 1 then
    print("Won't unload last buffer")
    return
  end

  local buf_handle = vim.api.nvim_get_current_buf()
  M.next_buf()
  vim.api.nvim_buf_delete(buf_handle, {unload=true})
end

function M.diagnostics()
  BufferInfo.diagnostics_called = BufferInfo.diagnostics_called + 1
  print(vim.inspect({
    buffers = BufferInfo.buffers,
    handles = BufferInfo.buf_handles,
    diagnostics_called = BufferInfo.diagnostics_called,
  }))
end

return M
