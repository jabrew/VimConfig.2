local cmp = require('cmp')
local cmp_config = require('cmp_nvim_lsp')
local nvim_lsp = require('lspconfig')

local kind_symbols = {
  Text = "",
  Method = "ƒ",
  Function = "",
  Constructor = "",
  Field = "ﴲ",
  Variable = "",
  Class = "פּ",
  Interface = "蘒",
  Module = "",
  Property = "",
  Unit = "塞",
  Value = "",
  Enum = "了",
  Keyword = "",
  Snippet = "",
  Color = "",
  File = "",
  Reference = "",
  Folder = "",
  EnumMember = "",
  Constant = "",
  Struct = " ",
  Event = "ﳅ",
  Operator = "",
  TypeParameter = " ",
  Default = ""
}

local source_symbols = {
  buffer = " ﬘",
  nvim_lsp = " ",
  luasnip = " 🐍",
  treesitter = " ",
  nvim_lua = " ",
  spell = " 暈",
}

-- TODO: Move bindings into mappings
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
  buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gI', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('i', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  buf_set_keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)

  -- Highlight current word
  require('illuminate').on_attach(client)
end

local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local luasnip = require("luasnip")

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
    -- TODO: How to get docs?
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), {'i', 'c'}),
    ['<C-e>'] = cmp.mapping.close(),
    -- ['<CR>'] = cmp.mapping.confirm({ select = false }),

    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      elseif has_words_before() then
        cmp.complete()
      else
        fallback()
      end
    end, { "i", "s" }),

    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),
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

nvim_lsp.pyright.setup({
  capabilities = cmp_config.update_capabilities(
    vim.lsp.protocol.make_client_capabilities()
  ),
  flags = {
    debounce_text_changes = 150,
  },
  on_attach = on_attach,
})

local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

-- https://jdhao.github.io/2021/08/12/nvim_sumneko_lua_conf/ has walkthrough
-- local sumneko_binary_path = vim.fn.exepath('lua-language-server')
local sumneko_binary_path = "C:\\Programs\\sumneko_lua_lsp\\bin\\lua-language-server.exe"
local sumneko_root_path = vim.fn.fnamemodify(sumneko_binary_path, ':h:h')

nvim_lsp.sumneko_lua.setup({
  capabilities = cmp_config.update_capabilities(
    vim.lsp.protocol.make_client_capabilities()
  ),
  flags = {
    debounce_text_changes = 150,
  },
  on_attach = on_attach,
  cmd = {
    sumneko_binary_path, "-E", sumneko_root_path .. "/main.lua"
  },
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT',
        -- Setup your lua path
        path = runtime_path,
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = {'vim'},
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file("", true),
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
    },
  },
})
