vim.o.runtimepath = vim.o.runtimepath .. ',~/VimConfig'

vim.opt.autoindent = true
vim.opt.cursorline = true
vim.o.termguicolors = true
-- vim.g.my_test_var = '35a'

-- TODO: Refactor? Maybe using vimpeccable to clean it up
vim.cmd([[
" Swap ; and : in normal mode
nnoremap : ;
nnoremap ; :
vnoremap : ;
vnoremap ; :

" TODO: Move and pull into lua
" Note: Seems maybe this is the best way to handle autocmd for now. At least add a group and enable for only gui
" Per-os settings {
  if has('win32')
    " TODO: Consider putting these into ginit.vim instead
    au VimEnter * GuiPopupmenu 0
    au VimEnter * GuiTabline 0
    " Consider SourceCodePro
    au VimEnter * Guifont! Consolas NF:h14
  else
  endif
" }

" TODO: Find a colorscheme
colorscheme jbrewer_desert
]])

local config = {}
local mappings = {}

-- Note: Bindings should go in mappings, to support lazy loading. There are some
-- exceptions - like arpeggio and cmp - that need to go in config

-- TODO: Move bindings into mappings
-- TODO: Take from NvChad instead of cmp
config.cmp = function()
  require('plugins.cmp')
end

config.telescope = function()
  require('plugins.telescope')
end

config.arpeggio = function()
  vim.fn['arpeggio#map']('i', '', 0, 'jk', '<Esc>')
  vim.fn['arpeggio#map']('c', '', 0, 'jk', '<C-c>')
  vim.fn['arpeggio#map']('v', '', 0, 'jk', '<Esc>')
  vim.fn['arpeggio#map']('o', '', 0, 'jk', '<Esc>')
end

config.blankline = function()
  require('indent_blankline').setup {
    indentLine_enabled = 1,
    char = '▏',
    filetype_exclude = {
      'help',
      'terminal',
      'dashboard',
      'packer',
      'lspinfo',
      'TelescopePrompt',
      'TelescopeResults',
    },
    buftype_exclude = { 'terminal' },
    show_trailing_blankline_indent = false,
    show_first_indent_level = false,
  }
end

config.treesitter = function()
  require('nvim-treesitter.configs').setup {
     ensure_installed = {
        'lua',
        'python',
     },
     highlight = {
        enable = true,
        use_languagetree = true,
     },
     -- Note: Part of matchup plugin
     matchup = {
       enable = true,
     }
  }
end

-- TODO: Clean
config.lsp_signature = function()
  require('lsp_signature').setup {
    bind = true,
    doc_lines = 2,
    floating_window = true,
    fix_pos = true,
    hint_enable = true,
    hint_prefix = ' ',
    hint_scheme = 'String',
    hi_parameter = 'Search',
    max_height = 22,
    max_width = 120, -- max_width of signature floating_window, line will be wrapped if exceed max_width
    handler_opts = {
      border = 'none', -- double, single, shadow, none
    },
    zindex = 200, -- by default it will be on top of all floating windows, set to 50 send it to bottom
    padding = '', -- character to pad on left and right of signature can be ' ', or '|'  etc
  }
end

config.luasnip = function()
  local luasnip = require('luasnip')

  luasnip.config.set_config {
    history = true,
    updateevents = 'TextChanged,TextChangedI',
  }
  -- TODO: Fix
  -- require("luasnip/loaders/from_vscode").load { path = { chadrc_config.plugins.options.luasnip.snippet_path } }
end

-- Note: Lexima handles repeat better, but this seems good enough - handles
-- single line repeats well
config.autopairs = function()
  require('nvim-autopairs').setup()
  require('nvim-autopairs.completion.cmp').setup({
    map_complete = true, -- insert () func completion
    map_cr = true,
  })
end

config.comment = function()
  require('nvim_comment').setup()
end

-- -- Install packer if it isn't present
-- local present, packer = pcall(require, "packer")
-- if not present then
--   local fn = vim.fn
--   local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
--   print("Packer not found - installing '" .. install_path .. "'")
--   if fn.empty(fn.glob(install_path)) > 0 then
--     fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
--     vim.cmd 'packadd packer.nvim'
--   end
-- end

-- TODO: Consider NvChad packer init - cleaner download boxes and setup
-- Note: Must be at end of file. Rather than trying to e.g. try to put things in
-- separate tiny files, its far easier to just place everything above,
-- especially for e.g. mappings. Larger configs without mappings may be moved
-- into plugins
--
-- TODO: Consider developing a file to treat multiple small logical files as a
-- single file - and then organizing this config
return require('packer').startup({
  function()
    -- Note: Ideally can simplify loading the configs by name, but doesn't work
    -- since packer has issues with some upvalues - see
    -- https://githubmemory.com/repo/wbthomason/packer.nvim/issues/351
    -- TODO: Get this working for both config and mappings
    -- local config_plugin = function(name)
    --   local saved_name = name
    --   return function()
    --     require('plugins.' .. saved_name)
    --   end
    -- end

    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    use 'nvim-lua/plenary.nvim'

    -- TODO: Find a treesitter supported scheme -
    -- https://github.com/rockerBOO/awesome-neovim#color
    -- Lots of plugin support - https://github.com/folke/tokyonight.nvim
    -- Aid to setting colors - https://github.com/rktjmp/lush.nvim
    -- use {
    --   'arcticicestudio/nord-vim',
    --   -- after = 'packer.nvim',
    --   config = function()
    --     vim.cmd([[colorscheme nord]])
    --   end,
    -- }
    -- Note: rktjmp/lush.nvim to quickly create colorschemes
    -- Looks ok, but background is tinted, same with sonokai
    -- use {
    --   'rafamadriz/neon',
    --   -- config = function() vim.cmd([[colorscheme neon]]) end,
    -- }
    -- use {
    --   'metalelf0/jellybeans-nvim',
    --   requires = {
    --     {'rktjmp/lush.nvim'},
    --   },
    -- }

    -- Ok options for building ones own
    -- use {
    --   'RRethy/nvim-base16',
    -- }
    -- use {
    --   'mhartington/oceanic-next',
    -- }
    -- use {
    --   'sainnhe/edge',
    -- }
    -- use {
    --   -- Not bad, tinted bg, hard to tell print vs self._bar colors
    --   'sainnhe/sonokai',
    -- }
    -- use {
    --   'tomasiser/vim-code-dark',
    --   -- config = function() vim.cmd([[colorscheme codedark]]) end,
    -- }
    -- use {
    --   -- Dimmed or dark_default are ok, but a little blue
    --   'projekt0n/github-nvim-theme',
    --   -- config = function() vim.cmd([[colorscheme github_dark_default]]) end,
    --   -- config = function() vim.cmd([[colorscheme github_dimmed]]) end,
    -- }

    -- Rejected:
    -- 'navarasu/onedark.nvim', -- Ok, neon slightly better
    -- 'EdenEast/nightfox.nvim',
    -- 'novakne/kosmikoa.nvim', -- Colors ok, aggressive italics, bad bg
    -- 'Th3Whit3Wolf/space-nvim', -- Also lots of italics
    -- 'glepnir/zephyr-nvim',
    -- 'Th3Whit3Wolf/one-nvim', -- Need to fix background, maybe worthwhile?
    -- 'mhartington/oceanic-next', -- Need to fix background, maybe worthwhile?
    -- 'Th3Whit3Wolf/onebuddy',
    -- 'tomasiser/vim-code-dark', -- A little too dark, can probably adjust bg
    -- 'sainnhe/edge',  -- Not as good as sonokai
    -- 'ellisonleao/gruvbox.nvim', -- Ok potentially

    use {
      'nvim-telescope/telescope.nvim',
      cmd = 'Telescope',
      config = config.telescope,
      module = 'telescope',
      requires = {
        {'nvim-lua/plenary.nvim'},
        {
          'nvim-telescope/telescope-fzf-native.nvim',
          run = 'make',
        },
      },
    }

    -- Note: For just esc, can use
    -- https://github.com/max397574/better-escape.nvim
    use {
      'kana/vim-arpeggio',
      config = config.arpeggio,
    }

    -- TODO: Take config from NvChad
    -- TODO: Test
    use 'kyazdani42/nvim-web-devicons'

    -- TODO: Take config from NvChad
    -- TODO: Font
    -- use {
    --   'famiu/feline.nvim',
    --   config = override_req('feline', 'plugins.configs.statusline'),
    -- }

    -- TODO: Fix - control color, make vertical spacing work - probably the font
    use {
      'lukas-reineke/indent-blankline.nvim',
      -- TODO: Debug - doesn't work with this
      -- event = 'BufRead',
      config = config.blankline,
    }

    -- TODO: Only on command
    -- use {
    --   'norcalli/nvim-colorizer.lua',
    --   event = 'BufRead',
    --   config = override_req('nvim_colorizer', '(plugins.configs.others).colorizer()'),
    -- }

    use {
      'nvim-treesitter/nvim-treesitter',
      event = 'BufRead',
      config = config.treesitter,
    }

    -- TODO: Fix
    -- use {
    --   'lewis6991/gitsigns.nvim',
    --   config = override_req('gitsigns', 'plugins.configs.gitsigns'),
    --   setup = function()
    --     require('core.utils').packer_lazy_load 'gitsigns.nvim'
    --   end,
    -- }

    use {
      'neovim/nvim-lspconfig',
      -- TODO: Lazy load based on filetype
      -- TODO: Coq needs to override this for some reason?
      -- TODO: Same with cmp
      -- config = function() require('plugins.lspconfig') end,
    }

    use {
      'hrsh7th/nvim-cmp',
      config = config.cmp,
      -- TODO: Consume
      -- config = override_req('nvim_cmp', 'plugins.configs.cmp'),
      requires = {
        {'hrsh7th/cmp-buffer'},
        {'hrsh7th/cmp-nvim-lsp'},
        {'hrsh7th/cmp-path'},
      },
    }

    -- TODO: Fix overlap issue - cmp and lsp popups collide
    -- use {
    --   'ray-x/lsp_signature.nvim',
    --   after = {
    --     'nvim-cmp',
    --     'nvim-lspconfig',
    --   },
    --   config = config.lsp_signature
    -- }

    use {
      'rafamadriz/friendly-snippets',
      event = 'InsertEnter',
    }

    use {
      'L3MON4D3/LuaSnip',
      wants = 'friendly-snippets',
      after = {
        'nvim-cmp',
      },
      config = config.luasnip,
    }

    use {
      'saadparwaiz1/cmp_luasnip',
      after = {
        'LuaSnip',
        'nvim-cmp',
      },
    }

    use {
      'hrsh7th/cmp-nvim-lua',
      after = {
        'LuaSnip',
        'nvim-cmp',
      },
    }

    -- TODO: Use endwise functionality to auto-end language constructs
    use {
      'windwp/nvim-autopairs',
      after = {
        'nvim-cmp',
      },
      config = config.autopairs,
    }

    -- TODO: Fix
    -- use {
    --   'glepnir/dashboard-nvim',
    --   config = override_req('dashboard', 'plugins.configs.dashboard'),
    --   setup = function()
    --     require('core.mappings').dashboard()
    --   end,
    -- }

    -- TODO: Python support
    use {
      'andymass/vim-matchup',
      -- Note: Also configured in treesitter
    }

    use {
      'terrortylor/nvim-comment',
      cmd = 'CommentToggle',
      config = config.comment,
      -- TODO: Fix
      -- setup = function()
      --   require('core.mappings').comment()
      -- end,
    }

    -- ----------Taken directly from old _nvimrc

    -- Alternative: AndrewRadev/splitjoin.vim - more popular, but doesn't seem to
    -- indent quite correctly
    use 'FooSoft/vim-argwrap'

    -- TODO: Needed?
    -- call dein#add('sbdchd/neoformat')

    -- TODO: Find treesitter/lua replacements
    -- -- Text objects
    -- call dein#add('kana/vim-textobj-user')
    -- -- e.g. vaf, vac (rebound below to vaC, conflicts with tcomment select comment)
    -- call dein#add('bps/vim-textobj-python', {'on_ft': 'python'})
    -- -- Alternative: https://github.com/vim-scripts/argtextobj.vim
    -- -- Older: call dein#add('vim-scripts/Parameter-Text-Objects')
    -- -- e.g. vi, - select parameter
    -- call dein#add('sgur/vim-textobj-parameter')
    -- -- e.g. vie - ie trims whitespace, ae selects entire
    -- call dein#add('kana/vim-textobj-entire')
    -- -- e.g. viv - camelCase or under_score part
    -- call dein#add('Julian/vim-textobj-variable-segment')
    -- -- e.g. vam - method, vaM - method chain
    -- call dein#add('thalesmello/vim-textobj-methodcall')
    -- -- e.g. A-k to move a line down - hjkl movements
    -- call dein#add('matze/vim-move')

    -- Lots of text objects - learn or replace with vim-textobj-*
    -- call dein#add('wellle/targets.vim')
    -- call dein#add('bkad/CamelCaseMotion')

    -- Works ok, but requires python2
    -- call dein#add('vim-scripts/swap-parameters')
    -- Way better than swap-parameters, but bindings conflict with tcomment (net:
    -- get rid of tcomment)
    -- g<, g> to move param, gs to enter swap mode
    -- call dein#add('machakann/vim-swap')

    -- Alternative: airblade/vim-gitgutter
    -- e.g. [c, ]c, [C, ]C - jump to chunk
    -- e.g. vig - select git chunk (mapped below)
    use 'mhinz/vim-signify'
    use 'tpope/vim-fugitive'

    use {
      'rhysd/git-messenger.vim',
      cmd = 'GitMessenger',
      keys = '<Plug>(git-messenger)',
    }

    -- Alternative: undotree
    -- Alternative: gundo
    -- Forks and extends gundo
    use {
      'simnalamburt/vim-mundo',
      cmd = 'MundoToggle',
    }

    -- Alternative: lh-tags, easytags, watch script, git rebase hook
    -- https://www.reddit.com/r/vim/comments/6ovppc/vimeasytags_alternative/
    -- Note: Easytags is not maintained, but has tag highlighting
    -- call dein#add('ludovicchabant/vim-gutentags')

    -- Alternative: https://github.com/tyru/caw.vim
    -- Removed for conflict with vim-swap
    -- call dein#add('tomtom/tcomment_vim')
    -- TODO: nvim-comment replaces?
    -- call dein#add('tpope/vim-commentary')
    -- TODO: Learn to use - some of the commands like cr*
    use 'tpope/vim-abolish'
    -- TODO: Replace (probably hop.nvim)
    -- call dein#add('easymotion/vim-easymotion')
    -- TODO: Replace
    -- call dein#add('hynek/vim-python-pep8-indent', {'on_ft': 'python'})
    -- call dein#add('tpope/vim-ragtag')
    use 'tpope/vim-repeat'
    use 'tpope/vim-surround'
    use 'tpope/vim-unimpaired'

    -- TODO: Session manager
    -- -- Alternative: tpope/vim-obsession
    -- call dein#add('xolox/vim-misc')
    -- call dein#add('xolox/vim-session')

    -- TODO: Find nvim alternative (probably telescope source)
    -- Show register preview window on " or @
    -- call dein#add('junegunn/vim-peekaboo')
    -- Lots of clipboard changes
    -- Alternative: YankRing
    -- Alternative: easyclip is split into several plugins - vim-subversive,
    -- vim-yoink, vim-cutlass
    -- Disadvantage: Seems to replace tons of functionality
    -- call dein#add('svermeulen/vim-easyclip')
    -- call dein#add('bfredl/nvim-miniyank')

    -- TODO: Find alternative
    -- -- Show open buffers, vertically
    -- -- Other options: horizontal tagbar
    -- -- vim-buftabline, vem-tabline
    -- -- Has a bug when deleting unknown buffers (e.g. :Pytest file -s)
    -- -- Fix: Add dictionary guard !has_key(s:bufPathDict, bufnr) to
    -- -- BuildBufferPathSignDict
    -- -- weynhamz is slightly newer
    -- -- call dein#add('fholgado/minibufexpl.vim')
    -- call dein#add('weynhamz/vim-plugin-minibufexpl')

    -- Command-mode keymaps
    use 'vim-utils/vim-husk'

    -- TODO: Verify works with lsp
    -- Note: Requires ctags with json support - e.g.
    -- brew install --HEAD --with-jansson universal-ctags/universal-ctags/universal-ctags
    -- Guide: http://liuchengxu.org/posts/vista.vim/
    use {
      'liuchengxu/vista.vim',
      ft = {
        'python',
      },
    }
    -- TODO: Probably not needed with new nvim
    -- Consider: https://github.com/haya14busa/incsearch-easymotion.vim
    -- call dein#add('haya14busa/incsearch.vim')

    -- ----------End taken directly from old _nvimrc

    -- use {
    --   -- Note: Installation likely requires calling :COQdeps
    --   'ms-jpq/coq_nvim',
    --   config = function() require('plugins.coq') end,
    --   requires = {
    --     {'neovim/nvim-lspconfig'},
    --   },
    -- }

    -- use {
    --   'ray-x/lsp_signature.nvim',
    --   config = function() require('plugins.lsp_signature') end,
    --   requires = {
    --     {'neovim/nvim-lspconfig'},
    --   },
    -- }

    -- TODO: Plugins
    -- - https://github.com/ray-x/navigator.lua - Go to definition, references
    -- - https://github.com/RishabhRD/nvim-lsputils - Code actions, references
    -- - https://github.com/folke/trouble.nvim - Lint, errors
    -- - https://github.com/jose-elias-alvarez/null-ls.nvim - Add external lint
    -- - kyazdani42/nvim-tree.lua or some other tree plugin (nvchad config)
    -- - lspkind - from nvim-cmp, better icons

  end,

  config = {
    auto_clean = true,
    compile_on_sync = true,
  }
})

--[[
TODOs:
- Directly use init.vim
- fzy instead of fzf for telescope? (and in cli)
- Packer setup lazy loading - https://www.reddit.com/r/neovim/comments/opipij/guide_tips_and_tricks_to_reduce_startup_and/
- Telescope vimwiki - https://www.reddit.com/r/neovim/comments/pyvelg/telescopevimwikinvim_just_a_quick_way_to_open_up/
- Separate gui commands - https://github.com/equalsraf/neovim-qt/issues/94

Themes:
- Nordic with extra color - https://www.reddit.com/r/neovim/comments/p237ig/neovim_nordic_rice/
--]]

-- Quick guide to the various vim pieces:
-- - https://github.com/nanotee/nvim-lua-guide
-- - https://vonheikemen.github.io/devlog/tools/configuring-neovim-using-lua/
-- Debug using :lua print(vim.o.runtimepath)
-- Autocomplete kind of works

-- NvChad init below - probably only used for testing
-- vim.o.runtimepath = vim.o.runtimepath .. ',~/NvChad'
-- -- Print commands will show at startup
-- -- print("Runtimepath: " .. vim.o.runtimepath)

-- -- Taken directly from NvChad init.lua
-- local ok, err = pcall(require, "core")
-- if not ok then
--    error("Error loading core" .. "\n\n" .. err)
-- end
