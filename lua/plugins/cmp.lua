local cmp = require('cmp')
local cmp_config = require('cmp_nvim_lsp')
local nvim_lsp = require('lspconfig')

local M = {}

M.on_list = function(options)
  -- Weird note - on_list gets called even with one result, and gets called
  -- before the cursor position changes. So we add the tag stack here instead of
  -- in jump_to_tag - if we add it there we get a new entry even when the cursor
  -- didn't move (note that cfirst changes the cursor position)
  local from = { vim.fn.bufnr('%'), vim.fn.line('.'), vim.fn.col('.'), 0 }
  local items = { { tagname = vim.fn.expand('<cword>'), from = from } }

  vim.fn.settagstack(vim.fn.win_getid(), { items = items }, 't')
  vim.fn.setqflist({}, ' ', options)
  vim.api.nvim_command('cfirst')
  -- vim.fn.setloclist(0, {}, ' ', options)
  -- vim.api.nvim_command('lopen')
end

M.jump_to_tag = function()
  vim.lsp.buf.definition({on_list=M.on_list})
end

local get_loc = function()
  return { vim.fn.bufnr('%'), vim.fn.line('.'), vim.fn.col('.'), 0 }
end

local locs_equal = function(lhs, rhs)
  assert(#lhs == 4)
  assert(#rhs == 4)
  return lhs[1] == rhs[1] and lhs[2] == rhs[2] and lhs[3] == rhs[3] and lhs[4] == rhs[4]
end

-- TODO: Consider instead lsp jump but use on_list to restrict results to
-- current file
M.jump_to_local_def = function()
  local from = get_loc()
  local items = { { tagname = vim.fn.expand('<cword>'), from = from } }

  vim.cmd('normal! gd')

  local new_loc = get_loc()
  if locs_equal(from, new_loc) then
    -- print("no move:" .. vim.inspect(from) .. " vs " .. vim.inspect(new_loc))
  else
    -- print("move:" .. vim.inspect(from) .. " vs " .. vim.inspect(new_loc))
    vim.fn.settagstack(vim.fn.win_getid(), { items = items }, 't')
  end
end

-- From https://github.com/hrsh7th/nvim-cmp/wiki/Menu-Appearance
-- TODO: Use more of that wiki
local kind_symbols = {
  Class = "󰠱",
  Color = "󰏘",
  Constant = "󰏿",
  Constructor = "",
  Default = "",
  Enum = "了",
  EnumMember = "",
  Event = "",
  Field = "󰇽",
  File = "󰈙",
  Folder = "󰉋",
  Function = "󰊕",
  Interface = "",
  Keyword = "󰌋",
  Method = "󰆧",
  Module = "",
  Operator = "󰆕",
  Property = "󰜢",
  Reference = "",
  Snippet = "",
  Struct = "",
  Text = "",
  TypeParameter = "󰅲",
  Unit = "",
  Value = "󰎠",
  Variable = "󰂡",
}
-- local kind_symbols = {
--   TextOld = "",
--   MethodOld = "ƒ",
--   FunctionOld = "",
--   ConstructorOld = "",
--   FieldOld = "ﴲ",
--   VariableOld = "",
--   ClassOld = "פּ",
--   InterfaceOld = "蘒",
--   ModuleOld = "",
--   PropertyOld = "",
--   UnitOld = "塞",
--   ValueOld = "",
--   EnumOld = "了",
--   KeywordOld = "",
--   SnippetOld = "",
--   ColorOld = "",
--   FileOld = "",
--   ReferenceOld = "",
--   FolderOld = "",
--   EnumMemberOld = "",
--   ConstantOld = "",
--   StructOld = " ",
--   EventOld = "ﳅ",
--   OperatorOld = "",
--   TypeParameterOld = " ",
--   DefaultOld = "",
-- }

-- Use https://www.nerdfonts.com/cheat-sheet to find symbols
-- Insert 8-bit - <c-v>uFFFF
-- Insert 16-bit - doesn't see to work (<c-v>U), but can just copy from https://github.com/ziontee113/icon-picker.nvim/blob/master/lua/icon-picker/icons/nf-v3-icon-list.lua
-- This isn't too reliable - plugin appears out of date
local source_symbols = {
  -- buffer = " ﬘",
  -- \udb82\udda8
  buffer = " 󰦪",
  -- nvim_lsp = " ",
  nvim_lsp = " 󰌨",
  -- luasnip = " 🐍",
  luasnip = " 󰩫",
  treesitter = " ",
  nvim_lua = " ",
  -- spell = " 暈",
  spell = " 󰓆",
}

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  -- Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions

  -- Note: At least python/lua don't do much with this, just copy C-] for nw
  -- buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  -- gd default is useful to go to the local definition. Also this tends to open
  -- up the location list
  -- buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  -- buf_set_keymap('n', '<C-]>', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'gD', '<cmd>lua require("plugins.cmp").jump_to_tag()<CR>', opts)
  buf_set_keymap('n', '<C-]>', '<cmd>lua require("plugins.cmp").jump_to_tag()<CR>', opts)
  -- gd but add to tag stack
  buf_set_keymap('n', 'gd', '<cmd>lua require("plugins.cmp").jump_to_local_def()<CR>', opts)
  buf_set_keymap('n', '<space>jl', 'gd', opts)
  buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gI', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('i', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  -- TODO: Start using code actions - should be useful esp for ruff
  -- Consider also better ui for this:
  -- https://github.com/nvim-telescope/telescope-ui-select.nvim
  -- https://github.com/stevearc/dressing.nvim
  buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  buf_set_keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)

  -- Highlight current word
  -- require('illuminate').on_attach(client)
end

local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local luasnip = require("luasnip")

local menu_select_helper = function(direction, fallback, can_expand)
  assert(direction == 1 or direction == -1)
  if cmp.visible() then
    if direction == 1 then
      cmp.select_next_item()
    else
      cmp.select_prev_item()
    end
  elseif can_expand and luasnip.expand_or_jumpable() then
    luasnip.expand_or_jump()
  elseif luasnip.jumpable(direction) then
    luasnip.jump(direction)
  elseif has_words_before() then
    cmp.complete()
  else
    fallback()
  end
end

cmp.setup({
  completion = {
    completeopt = 'noinsert,menuone,noselect',
  },
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  mapping = {
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), {'i', 'c'}),
    ['<C-e>'] = cmp.mapping.close(),

    -- ['<CR>'] = cmp.mapping.confirm({ select = false }),
    ['<C-J>'] = cmp.mapping.confirm({ select = true }),

    ["<C-N>"] = cmp.mapping(function(fallback)
      return menu_select_helper(1, fallback, false)
    end, { "i", "s", "c" }),
    ["<Tab>"] = cmp.mapping(function(fallback)
      return menu_select_helper(1, fallback, true)
    end, { "i", "s", "c" }),

    ["<C-P>"] = cmp.mapping(function(fallback)
      return menu_select_helper(-1, fallback, false)
    end, { "i", "s", "c" }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      return menu_select_helper(-1, fallback, false)
    end, { "i", "s", "c" }),
  },
  formatting = {
    -- Taken from ray-x/navigator.lua
    format = function(entry, vim_item)
      function cmp_kind(kind) return kind_symbols[kind] or "" end
      vim_item.kind = cmp_kind(vim_item.kind)
      vim_item.menu = source_symbols[entry.source.name]
      return vim_item
    end,
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'buffer' },
    { name = 'nvim_lua' },
    { name = 'path' },
    { name = 'spell', keyword_length = 4 },
    { name = 'nvim_lsp_document_symbol' },
    { name = 'greek' },
    { name = 'nvim_lsp_signature_help' },
    { name = 'treesitter' },
  },
  view = {
    -- Note: Maybe fixed as of 0.7.1-pre
    -- Without this, undo history breaks. Easiest repro to test:
    -- Open python file
    -- def example()
    --   if True:
    --     print("F")
    --   else:
    --     print("G")
    -- <hit newline twice>
    -- entries = 'native',
  },
})
local search_sources = {
  sources = cmp.config.sources({
    { name = "nvim_lsp_document_symbol", keyword_length = 4 },
  }, {
    { name = "buffer", keyword_length = 4 },
  }),
}
-- Use buffer source for `/`.
cmp.setup.cmdline("/", search_sources)
cmp.setup.cmdline("?", search_sources)
cmp.setup.cmdline(":", {
  sources = {
    { name = "cmdline", keyword_length = 3 },
    { name = "path", keyword_length = 3 },
  },
})

-- TODO: Also add type checkers (mypy or pytype or pyre - they include :infer to
-- guess the type of some code)
-- TODO: Also add linters - ruff
-- To add a language server - install using :MasonInstall, add to mason config
-- in init.lua, then add here
nvim_lsp.pyright.setup({
  capabilities = cmp_config.default_capabilities(),
  flags = {
    debounce_text_changes = 150,
  },
  on_attach = on_attach,
  settings = {
    python = {
      analysis = {
        -- Without this it usually won't find project-local files
        autoSearchPaths = true,
        -- TODO: If this is really slow, try to disable
        useLibraryCodeForTypes = true,
      },
    },
  },
})

nvim_lsp.ruff_lsp.setup({
  init_options = {
    settings = {
      -- Any extra CLI arguments for `ruff` go here.
      args = {},
    },
  },
})

local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

nvim_lsp.lua_ls.setup({
  capabilities = cmp_config.default_capabilities(),
  flags = {
    debounce_text_changes = 150,
  },
  on_attach = on_attach,
  -- cmd = {
  --   sumneko_binary_path, "-E", sumneko_root_path .. "/main.lua"
  -- },
  settings = {
    Lua = {
      -- runtime = {
      --   -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
      --   version = 'LuaJIT',
      --   -- Setup your lua path
      --   path = runtime_path,
      -- },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = {'vim'},
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file("", true),
        checkThirdParty = false,
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
    },
  },
})

return M

-- -- https://jdhao.github.io/2021/08/12/nvim_sumneko_lua_conf/ has walkthrough
-- -- local sumneko_binary_path = vim.fn.exepath('lua-language-server')
-- local sumneko_binary_path = "C:\\Programs\\sumneko_lua_lsp\\bin\\lua-language-server.exe"
-- local sumneko_root_path = vim.fn.fnamemodify(sumneko_binary_path, ':h:h')
--
-- nvim_lsp.sumneko_lua.setup({
--   capabilities = cmp_config.default_capabilities(),
--   flags = {
--     debounce_text_changes = 150,
--   },
--   on_attach = on_attach,
--   cmd = {
--     sumneko_binary_path, "-E", sumneko_root_path .. "/main.lua"
--   },
--   settings = {
--     Lua = {
--       runtime = {
--         -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
--         version = 'LuaJIT',
--         -- Setup your lua path
--         path = runtime_path,
--       },
--       diagnostics = {
--         -- Get the language server to recognize the `vim` global
--         globals = {'vim'},
--       },
--       workspace = {
--         -- Make the server aware of Neovim runtime files
--         library = vim.api.nvim_get_runtime_file("", true),
--       },
--       -- Do not send telemetry data containing a randomized but unique identifier
--       telemetry = {
--         enable = false,
--       },
--     },
--   },
-- })
