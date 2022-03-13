vim.o.runtimepath = vim.o.runtimepath .. ',~/VimConfig'

vim.opt.autoindent = true
vim.opt.cursorline = true
vim.o.termguicolors = true
-- vim.g.my_test_var = '35a'

-- TODO: Refactor? Maybe using vimpeccable to clean it up
vim.cmd([[

" TODO: Find a colorscheme
colorscheme jbrewer_desert

" Basics {
  " let g:jellybeans_overrides = {
  "       \     'background': { 'guibg': '2d2d2d' },
  "       \ }
  " colorscheme jellybeans
  colorscheme jbrewer_desert

  set nocompatible
  set ruler
  set ignorecase
  set smartcase
  set incsearch
  set hlsearch
  set mouse=a

  " Automatically resize all windows
  set equalalways

  " TODO: Consider 'showfulltag' for autocomplete
  set showcmd
  set wildmode=list:longest,full

  if has('win32')
    set lcs=tab:»\ ,trail:·,extends:#,nbsp:.
  else
    set lcs=tab:»\ ,trail:·,extends:#,nbsp:.
  endif
  set list

  set number

  set wildmenu
  " Keep at least 5 lines above and below the cursor
  set scrolloff=5
  " May cause flashing on startup
  set lazyredraw

  set vb t_vb=

  set formatoptions=croqlnj
  " set cursorline

  " set completeopt=menuone,menu,longest,preview
  " Used for ncm2 (important: breaks if not specified)
  set completeopt=noinsert,menuone,noselect

  " Get rid of autocomplete popup info ("The only match", etc)
  set shortmess+=c

  " From http://ksjoberg.com/vim-esckeys.html , this should help the issue
  " where pushing esc takes a while to take effect
  " set noesckeys

  " To set up vimwiki (MacVim):
  " cd /Applications
  " cp -r MacVim.app/ VimWiki.app/
  " cd VimWiki.app/Contents/
  " gvim Info.plist
  " - Replace CFBundleName >MacVim< with >VimWiki<

  let g:mycwd = getcwd()
  if g:mycwd == expand('~/vimwiki') || g:mycwd == '~/vimwiki' || (!has('gui_running') && !has('nvim'))
    let g:is_tabbed = 1
  else
    let g:is_tabbed = 0
  endif
  if g:mycwd == expand('~/vimwiki') || g:mycwd == '~/vimwiki'
    let g:is_wiki = 1
  else
    let g:is_wiki = 0
  endif

  " https://vi.stackexchange.com/questions/10065/how-can-i-show-the-containing-directory-in-the-window-title
  " TODO: Set this more accurately (v:servername from 'title' doesn't work)
  " Consider something like
  " https://coderwall.com/p/lznfyw/better-title-string-for-vim
  let g:window_name = 'NVIM'
  if g:is_wiki
    let g:window_name = 'VIMWIKI'
  endif
  set titlestring=%t%(\ %M%)%(\ %h%)%(\ (%{expand(\"%:~:.:h\")})%)%(\ %a%)%(\ -\ %{g:window_name}%)
" }

" Note: Seems maybe this is the best way to handle autocmd for now. At least add a group and enable for only gui
" Per-os settings {
  if has('win32')
    au VimEnter * GuiPopupmenu 0
    au VimEnter * GuiTabline 0
    " Consider SourceCodePro
    au VimEnter * Guifont! Consolas NF:h14
  else
  endif

  " Window size keybindings
  " TODO: Move into mac specific
  " TODO: Consider moving into an init function align with notifyWindowActive
  if g:is_wiki
    " TODO: Need to also resize the window
    " NeoVim: Lines 40, columns 86
    " MacVim: Lines 40, columns 84
    nnoremap <silent> <Leader>wn :silent !hs -c "windowPosition('cur', 'right', 'bottom', 778, 786)"<CR>
    silent !hs -c "windowPosition('cur', 'right', 'bottom', 778, 786)"
    " self.proc_by_name('VimWiki'), 759, 809),
  else
    if has('win32')
      " Lines 42, columns 117
      " nnoremap <silent> <Leader>wn :silent !start C:\Users\Brew\Documents\Autohotkey\SizeWindow.ahk windowPosition cur center top 1186 963 -156<CR>
      " silent !start C:\Users\Brew\Documents\Autohotkey\SizeWindow.ahk windowPosition cur center top 1186 963 -156
      nnoremap <silent> <Leader>wn :silent !start C:\Users\jason\dotfiles\windows\Autohotkey\SizeWindow.ahk windowPosition cur center top 1186 963 -156<CR>
      silent !start C:\Users\jason\dotfiles\windows\Autohotkey\SizeWindow.ahk windowPosition cur center top 1186 963 -156
    else
      " Lines 42, columns 117
      nnoremap <silent> <Leader>wn :silent !hs -c "windowPosition('cur', 'center', 'top', 1057, 824, -139)"<CR>
      " TODO: Doesn't seem to work consistently - maybe has to do with width of
      " MBE window?
      nnoremap <silent> <Leader>wl :silent !hs -c "windowPosition('cur', 'center', 'top', 1840, 976, 234)"<CR>
      " silent !hs -c "windowPosition('cur', 'center', 'top', 1057, 824, -139)"
      " Note: equalalways seems to not quite equalize windows
      silent !hs -c "windowPosition('cur', 'center', 'top', 0, 0, -139)"
    endif
  endif

  " Notify hammerspoon the window is active
  " TODO: Consider also notifying hammerspoon on WinEnter
  if has('win32')
  else
    if v:vim_did_enter
      silent !hs -c "notifyWindowActive()"
    else
      au VimEnter * silent !hs -c "notifyWindowActive()"
    endif
  endif
" }

" Global keybindings {
  " Select last pasted test
  " From: https://vim.fandom.com/wiki/Selecting_your_pasted_text
  " nnoremap gp `[v`]
  nnoremap <expr> gp '`[' . strpart(getregtype(), 0, 1) . '`]'

  " Swap ; and : in normal mode
  nnoremap : ;
  nnoremap ; :
  vnoremap : ;
  vnoremap ; :

  if g:is_tabbed == 1
    nnoremap <C-P> :tabp<CR>
    nnoremap <C-N> :tabn<CR>
    nnoremap <Leader>p :bp<CR>
    nnoremap <Leader>n :bn<CR>
  else
    nnoremap <silent> <C-P> :bp<CR>
    nnoremap <silent> <C-N> :bn<CR>
    " nnoremap <silent> <C-P> :MBEbp<CR>
    " nnoremap <silent> <C-N> :MBEbn<CR>
    nnoremap <silent> <Leader>p :tabp<CR>
    nnoremap <silent> <Leader>n :tabn<CR>
  endif

  noremap <M-g> <C-U>
  noremap © <C-U>
  noremap <M-b> <C-D>
  noremap ∫ <C-D>

  nnoremap <silent> <leader>h :silent :nohlsearch<CR>

  " :tjump instead of :tag
  nnoremap <C-]> g<C-]>

  " Swap ' and ` (default ` jumps to mark line and column, while ' just jumps to line, this makes the more useful binding
  " ')
  nnoremap ' `
  nnoremap ` '

  nnoremap <Up> <C-W>k
  nnoremap <Down> <C-W>j
  nnoremap <Left> <C-W>h
  nnoremap <Right> <C-W>l

" }

" netrw {
  " When accidentially opening netrw windows, this makes them close as soon as
  " another window is activated. May need to close/open MBE
  let g:netrw_fastbrowse = 0
  autocmd FileType netrw setl bufhidden=wipe
" }

" glrnvim config {
  " Mostly within config:
  " Linux: ~/.config/glrnvim.yml
  " Mac: ~/Library/Preferences/glrnvim.yml
  " Windows: ~\AppData\Roaming\glrnvim.yml
" }

" Space keybindings {
  " Space bindings - should be very organized and easy to use, but harder to
  " type. Any very frequently used bindings should be moved to dedicated keys
  " TODO: Use plugin to visualize/hint these

  " Clipboard (c)
  vnoremap <Space>cy "*y
  vnoremap <Space>cp "*p

  nnoremap <Space>cy "*y
  nnoremap <Space>cp "*p
  nnoremap <Space>cP "*P

  " More (c) bindings under nvim-miniyank

  " Convert slashes to backslashes for Windows.
  if has('win32')
    nnoremap <Space>cf :let @*=substitute(expand("%"), "/", "\\", "g")<CR>
    nnoremap <Space>cg :let @*=substitute(expand("%:p"), "/", "\\", "g")<CR>
  else
    " Copy filename
    nnoremap <Space>cf :let @*=expand("%")<CR>
    " Copy full path of file
    nnoremap <Space>cg :let @*=expand("%:p")<CR>
  endif

  " Files (f)

  nnoremap <Space>fw :w<CR>
  nnoremap <Space>fq :wqa<CR>

  " Note: Bindings for plugins in separate sections

  " TODO: Update below
  " Jedi (j)
  " Denite/fzf (f)
  " NeoFormat (=)
  " Git (git-messenger) (g)
  " pytest.vim (t)
  " vim-session (s)
" }

" Indentation and editing options {
    filetype on
    syntax enable

    filetype indent on
    filetype plugin on

    set tabstop=2
    set shiftwidth=2
    set expandtab
    set textwidth=80
    "set smarttab

    " Sets indentation options (new lines match last open paren, etc)
    set cinoptions=>s,e0,n0,f0,{0,}0,^0,:s,=s,l0,b0,gs,hs,ps,ts,is,+s,c3,C0,/0,(0,us,U0,w0,Ws,m1,j0,)20,*70,N-s
    " Original: set cinoptions=>s,e0,n0,f0,{0,}0,^0,:s,=s,l0,b0,gs,hs,ps,ts,is,+s,c3,C0,/0,(2s,us,U0,w0,W0,m0,j0,)20,*30

    set autoindent
    set smartindent
    " Stop smartindent from putting # at column 1
    inoremap # X#
    set cindent

    set whichwrap+=<,>,b           " Backspace and cursor keys wrap
    set backspace=2                  " Normal backspace behavior

    " Keep buffers open even after backgrounding them
    set hidden

    " Tab options
    if g:is_tabbed
      set showtabline=2
    else
      set showtabline=1
    endif
    " if g:is_wiki
    "   set showtabline=1
    " endif
    set switchbuf=usetab

    " Python indentation
    let g:pyindent_open_paren = '&sw'
    let g:pyindent_continue = '&sw'
" }

" Auto commands {
    "au GUIEnter * simalt ~x

    " au TabEnter * source ~/VimConfig/TabEnter.vim
    " TODO: If indenting doesn't work right, consider adding ts=2
    au FileType ruby,eruby,yaml setl ai sw=2 sts=2 et
    au FileType cpp set ai sw=2 sts=2 et
    au FileType python setl ai sw=4 sts=4 et
    au FileType javascript setl ai sw=4 sts=4 et
    au FileType jinja setl ai sw=4 sts=4 et
    au FileType go setl ai sw=4 sts=4 et

    "au Filetype html,xml,xsl source ~\vimfiles\bundle\closetag.vim
    "autocmd FileType ruby,eruby set omnifunc=rubycomplete#Complete
    " Curretly disabled as it tends to lag out on big folders
    au FileType python set omnifunc=

    " Always show sign column
    au FileType python setl signcolumn=yes:1

    " Helps issue where long multiline strings or comments cause syntax to get
    " out of sync
    au FileType python syn sync minlines=2000

    " Go to last line in given file
    autocmd BufReadPost *
        \ if line("'\"") > 1 && line("'\"") <= line("$") |
        \ exe "normal! g`\"" |
        \ endif
" }

" Additional Filetypes {
  augroup filetypedetect
    au BufRead,BufNewFile *.thrift         setfiletype thrift
    au BufRead,BufNewFile *.proto         setfiletype proto
  augroup END
" }

" Status line and ruler formats {
    set title
    set laststatus=2

    " " Broken down into easily includeable segments
    " set statusline=%<%f\   " Filename
    " set statusline+=%w%h%m%r " Options
    " "set statusline+=%{fugitive#statusline()} "  Git Hotness
    " set statusline+=\ [%{&ff}/%{strlen(&fenc)?&fenc:'noenc'}/%{strlen(&ft)?&ft:'notype'}]            " filetype
    " set statusline+=\ [%{getcwd()}]          " current dir
    " " set statusline+=\ %#Error#%{SyntasticStatuslineFlag()}%*
    " set statusline+=\ %#Error#%{AleStatusLineFlag()}%*
    " "set statusline+=\ [A=\%03.3b/H=\%02.2B] " ASCII / Hexadecimal value of char
    " set statusline+=%=%-14.(%l/%L,%c%V%)\ %p%%  " Right aligned file nav info

    set rulerformat=%30(%=\:b%n\ %y%m%r%w\ %l/%L,%c%V\ %P%)
" }

" TODO: Add "Search for visually selected text with *

" Highlight anything past character 80 {
    let g:marginHighlighted = 0
    function! ToggleMarginHighlight()
        highlight LineTooLong term=bold gui=bold ctermfg=red guifg=red
        if g:marginHighlighted
            let g:marginHighlighted = 0
            match
        else
            let g:marginHighlighted = 1
            " match LineTooLong /.\%>80v/
            match LineTooLong /\%81v.\+/
        endif
    endfunction
    nmap <leader>m ;silent exe "call ToggleMarginHighlight()"<CR>
" }

if filereadable(expand("~/dotfiles_snap/_nvimrc"))
  source ~/dotfiles_snap/_nvimrc
endif

]])

local config = {}
local mappings = {}

-- Note: Bindings should go in mappings, to support lazy loading. There are some
-- exceptions - like arpeggio and cmp - that need to go in config

-- TODO: Move bindings into mappings
-- TODO: Take from NvChad instead of cmp
-- Note: nvim post 0.6.x supports nicer lua mappings and autocommands
config.cmp = function()
  require('plugins.cmp')
  vim.cmd([[
    inoremap <expr> <CR> (pumvisible() ? "\<c-y>\<cr>" : "\<CR>")
  ]])
end

config.coq = function()
  require('plugins.coq')
end

config.telescope = function()
  require('plugins.telescope')
end

config.arpeggio = function()
  vim.fn['arpeggio#map']('i', '', 0, 'jk', '<Esc>')
  vim.fn['arpeggio#map']('c', '', 0, 'jk', '<C-c>')
  vim.fn['arpeggio#map']('v', '', 0, 'jk', '<Esc>')
  vim.fn['arpeggio#map']('o', '', 0, 'jk', '<Esc>')
  -- TODO: Port the rest of these over
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

-- TODO: Mappings
config.luasnip = function()
  local luasnip = require('luasnip')

  luasnip.config.set_config {
    history = true,
    updateevents = 'TextChanged,TextChangedI',
  }
  -- TODO: Fix
  -- require("luasnip/loaders/from_vscode").load { path = { chadrc_config.plugins.options.luasnip.snippet_path } }
end

config.trouble = function()
  require('trouble').setup({
  })
end

config.minibufexpl = function()
  vim.cmd([[
    if g:is_tabbed == 1
      let g:miniBufExplorerAutoStart = 0
    else
      let g:miniBufExplVSplit = 30   " Column width in chars
      let g:miniBufExplBRSplit = 0   " Split on left

      let g:miniBufExplorerAutoStart = 1
      let g:miniBufExplBuffersNeeded = 0
      let g:miniBufExplShowBufNumbers = 0
      let g:miniBufExplCycleArround = 1
    endif
  ]])
end

mappings.autosession = function()
  vim.cmd([[
  nnoremap <Space>ss :SaveSession<CR>
  nnoremap <Space>sr :RestoreSession<CR>
  nnoremap <Space>sd :DeleteSession<CR>
  ]])
end

config.autosession = function()
  vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal"
  require('auto-session').setup({
    log_level = 'info',
    auto_session_suppress_dirs = {'~/', '~/Projects'}
  })
end

mappings.packer = function()
  vim.cmd([[
    nnoremap <Space>pi :PackerInstall<CR>
    nnoremap <Space>pc :PackerCompile<CR>
    ]])
end
-- TODO: Fix - see comment in packer config
mappings.packer()

mappings.minibufexpl = function()
  vim.cmd([[
    if g:is_tabbed == 1
      nnoremap <Leader>d :bd<CR>
    else
      nnoremap <Leader>d :MBEbd<CR>
    endif
  ]])
end

config.argwrap = function()
  vim.g.argwrap_tail_comma_braces = '[{'
end

mappings.argwrap = function()
  vim.cmd([[
    nnoremap <silent> <Leader>= :ArgWrap<CR>
  ]])
end

mappings.husk = function()
  vim.cmd([[
    " Map <M-B> and <M-F> (mapping <M-B> directly within mac doesn't work)
    cnoremap <expr> ∫ husk#left()
    cnoremap <expr> ƒ husk#right()
    cnoremap <expr> <M-B> husk#left()
    cnoremap <expr> <M-F> husk#right()
  ]])
end

config.textobj_python = function()
  vim.cmd([[
    xmap aC <Plug>(textobj-python-class-a)
    omap aC <Plug>(textobj-python-class-a)
    xmap iC <Plug>(textobj-python-class-i)
    omap iC <Plug>(textobj-python-class-i)
  ]])
end

-- Note: Braceless causes weird issues with lsp autocomplete plugins - type e.g.
-- Blah (triggers completion menu), then hitting enter without accepting
-- completion, then undo doesn't work - has extra garbage characters
-- TODO: Find replacement or fix bug - likely one with braceless' <cr> mapping
-- TODO: May have fixed this elsewhere? Mac?
config.braceless = function()
  vim.cmd([[
    autocmd FileType python BracelessEnable +indent
  ]])
end

config.signify = function()
  vim.cmd([[
    let g:signify_vcs_list = ['git']
  ]])
end

mappings.signify = function()
  vim.cmd([[
    omap ig <Plug>(signify-motion-inner-pending)
    xmap ig <Plug>(signify-motion-inner-visual)
    omap ag <Plug>(signify-motion-outer-pending)
    xmap ag <Plug>(signify-motion-outer-visual)
  ]])
end

mappings.git_messenger = function()
  vim.cmd([[
    nnoremap <Space>gm :GitMessenger<CR>
  ]])
end

config.vista = function()
  vim.cmd([[
  let g:vista_fzf_preview = ['right:50%']
  let g:vista#renderer#enable_icon = 1
  " let g:vista_icon_indent = ["╰─▸ ", "├─▸ "]
  let g:vista_icon_indent = ["▸ ", ""]
  let g:vista#renderer#icons = {
  \   "function": "\uf794",
  \   "variable": "\uf71b",
  \  }
  ]])
end

-- Note: Lexima handles repeat better, but this seems good enough - handles
-- single line repeats well, though multiline can get glitchy
-- Note: There's an issue with <CR> with the preview menu up - repro:
-- <text to trigger autocomplete><c-n><cr> - undo will break and add an extra
-- line. Maybe autopairs, so try lexima
-- Note: Above issue is probably braceless with <cr> mapped
config.autopairs = function()
  require('nvim-autopairs').setup({
    map_cr = false,
  })
  -- TODO: Confirm not needed - seems to have been deprecated/fixed
  -- require('nvim-autopairs.completion.cmp').setup({
  --   map_complete = true, -- insert () func completion
  --   map_cr = true,
  -- })
end

config.lexima = function()
  vim.g.lexima_enable_basic_rules = 1
  vim.g.lexima_enable_newline_rules = 1
  vim.g.lexima_enable_endwise_rules = 1
  vim.g.lexima_nvim_accept_pum_with_enter = 0
end

config.comment = function()
  require('Comment').setup()
end

mappings.lightspeed = function()
  -- vim.cmd([[
  --   silent! unmap s
  --   silent! unmap S
  -- ]])
  --
  -- vim.fn['arpeggio#map']('n', '', 0, 'we', '<Plug>Lightspeed_S')
  -- vim.fn['arpeggio#map']('n', '', 0, 'cv', '<Plug>Lightspeed_s')
end

config.lightspeed = function()
  -- TODO: For some reason this doesn't work - why?
  -- mappings.lightspeed()
  vim.cmd([[
    silent! unmap s
    silent! unmap S
  ]])

  vim.fn['arpeggio#map']('n', '', 0, 'we', '<Plug>(Lightspeed_S)')
  vim.fn['arpeggio#map']('n', '', 0, 'cv', '<Plug>(Lightspeed_s)')
end

config.hop = function()
  require('hop').setup()
  -- TODO: Add mappings for e.g. line/word/operator mode - like easymotion ,w
  -- TODO: Consider MW variant (multiple window)
  vim.fn['arpeggio#map']('n', '', 0, 'we', ':HopChar2<CR>')
  vim.fn['arpeggio#map']('v', '', 0, 'we', '<cmd>HopChar2<CR>')
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

-- TODO: Packer is only supposed to be init'ed when updating packages? Though
-- may be simpler to keep as-is
-- TODO: Consider NvChad packer init - cleaner download boxes and setup
-- Note: Must be at end of file. Rather than trying to e.g. try to put things in
-- separate tiny files, its far easier to just place everything above,
-- especially for e.g. mappings. Larger configs without mappings may be moved
-- into plugins
--
-- TODO: Consider developing a plugin to treat multiple small logical files as a
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
    -- TODO: Add setup/mappings here. Instead we add them globally because
    -- otherwise packer keeps trying to remove itself on any config change
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
      -- Treesitter recommends running this on startup, but seems too often
      -- run = ':TSUpdate',
      -- event = 'BufRead',
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
      -- TODO: Coq needs to override this for some reason?
      -- TODO: Same with cmp
      -- TODO: Find a cleaner way to handle this
      -- config = function() require('plugins.lspconfig') end,
    }

    -- TODO: Decide
    local completionEngine = 'cmp'
    if completionEngine == 'coq' then
      use {
        'ms-jpq/coq_nvim',
        branch = 'coq',
        config = config.coq,
        requires = {
          {'neovim/nvim-lspconfig'},
        },
      }
    elseif completionEngine == 'cmp' then
      use {
        'hrsh7th/nvim-cmp',
        -- Take native_menu out, once the bugs are fixed - breaks undo - see
        -- cmp.lua for repro
        config = config.cmp,
        -- TODO: Consume this config, rather than copy+paste here and in coq
        -- config = override_req('nvim_cmp', 'plugins.configs.cmp'),
        requires = {
          {'hrsh7th/cmp-buffer'},
          {'hrsh7th/cmp-nvim-lsp'},
          {'hrsh7th/cmp-path'},
        },
      }

      -- Note: Useful, but disabled for now since it overlaps the autocomplete
      -- popup. Potential fixes:
      -- - Show in static window instead - requires a lot of code changes
      -- - Use another completor - e.g. nvim-cmp or lspsaga have their own
      --    floating windows and can manage this too, though cmp's floating
      --    window has its own bugs - see comment there
      -- use {
      --   'ray-x/lsp_signature.nvim',
      --   after = {
      --     'nvim-cmp',
      --     'nvim-lspconfig',
      --   },
      --   config = config.lsp_signature,
      --   requires = {
      --     {'neovim/nvim-lspconfig'},
      --   },
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
    else
      error('Invalid completion engine ' .. completionEngine)
    end

    use {
      'folke/trouble.nvim',
      requires = 'kyazdani42/nvim-web-devicons',
      config = config.trouble,
    }

    -- TODO:
    -- - Fix colors and icons in cmp/coq to show e.g. source
    -- - Snippets plugin
    -- - Fix pairs and braceless for quality editing

    -- TODO: Use endwise functionality to auto-end language constructs
    use {
      'windwp/nvim-autopairs',
      after = {
        'nvim-cmp',
      },
      config = config.autopairs,
    }
    -- use {
    --   'cohama/lexima.vim',
    --   after = {
    --     -- 'nvim-cmp',
    --   },
    --   config = config.lexima,
    -- }

    use {
      'andymass/vim-matchup',
      -- Note: Configured in treesitter - need to edit that config instead
    }

    -- Nice for per-language mappings, but can't get it to stop adding a space
    -- after comment lines
    -- tpope/vim-commentary doesn't have the option either
    -- use {
    --   'terrortylor/nvim-comment',
    --   -- cmd = {'CommentToggle', 'CommentOperator'},
    --   config = config.comment,
    --   setup = mappings.comment,
    --   event = 'BufRead',
    -- }
    -- TODO: Learn some of the extra mappings
    use {
      'numToStr/Comment.nvim',
      config = config.comment,
    }

    -- ----------Taken directly from old _nvimrc

    -- Alternative: AndrewRadev/splitjoin.vim - more popular, but doesn't seem to
    -- indent quite correctly
    use {
      'FooSoft/vim-argwrap',
      cmd = 'ArgWrap',
      config = config.argwrap,
      setup = mappings.argwrap,
    }

    -- TODO: Needed? LSP may do format
    -- TODO: Replace?
    -- call dein#add('sbdchd/neoformat')

    -- TODO: Find treesitter/lua replacements
    -- Text objects
    -- e.g. vaf, vac (rebound below to vaC, conflicts with tcomment select comment)
    use {
      'bps/vim-textobj-python',
      config = config.textobj_python,
      ft = {
        'python',
      },
      requires = {
        {'kana/vim-textobj-user'},
      }
    }
    -- Alternative: https://github.com/vim-scripts/argtextobj.vim
    -- Older: call dein#add('vim-scripts/Parameter-Text-Objects')
    -- e.g. vi, - select parameter
    use {
      'sgur/vim-textobj-parameter',
      requires = {
        {'kana/vim-textobj-user'},
      }
    }
    -- e.g. vie - ie trims whitespace, ae selects entire
    use {
      'kana/vim-textobj-entire',
      requires = {
        {'kana/vim-textobj-user'},
      }
    }
    -- e.g. viv - camelCase or under_score part
    use {
      'Julian/vim-textobj-variable-segment',
      requires = {
        {'kana/vim-textobj-user'},
      }
    }
    -- e.g. vam - method, vaM - method chain
    use {
      'thalesmello/vim-textobj-methodcall',
      requires = {
        {'kana/vim-textobj-user'},
      }
    }
    -- TODO: Keep or remove below - add bindings as well
    -- -- e.g. A-k to move a line down - hjkl movements
    -- call dein#add('matze/vim-move')

    -- TODO: Keep or remove below
    -- Lots of text objects - learn or replace with vim-textobj-*
    -- call dein#add('wellle/targets.vim')
    -- * Has config
    -- call dein#add('bkad/CamelCaseMotion')

    -- Works ok, but requires python2
    -- call dein#add('vim-scripts/swap-parameters')
    -- Way better than swap-parameters, but bindings conflict with tcomment (net:
    -- get rid of tcomment)
    -- g<, g> to move param, gs to enter swap mode
    use 'machakann/vim-swap'

    -- Alternative: airblade/vim-gitgutter
    -- e.g. [c, ]c, [C, ]C - jump to chunk
    -- e.g. vig - select git chunk (mapped below)
    use {
      'mhinz/vim-signify',
      setup = mappings.signify,
      config = config.signify,
    }
    use 'tpope/vim-fugitive'

    use {
      'rhysd/git-messenger.vim',
      setup = config.git_messenger,
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

    -- Options:
    -- - easymotion/sneak - older and vim focused
    -- - hop.nvim
    use {
      'phaazon/hop.nvim',
      branch = 'v1',
      config = config.hop(),
    }
    -- - lightspeed.nvim - seems most active, supports multi-window seek
    -- Issues:
    -- - No way to just seek two characters globally - really wants to operate
    --  from cursor
    -- - A little weird to get used to. Might be worth it if not for the above
    --  issue. E.g. auto jumps early if you enter a unique first char, timeouts
    --  on repeated jumps for f are REALLY low, etc
    -- use {
    --   'ggandor/lightspeed.nvim',
    --   -- Config also does mappings, since these use arpeggio
    --   -- TODO: Use autocommands for the mappings instead
    --   config = config.lightspeed,
    --   requires = {
    --     {'kana/vim-arpeggio'},
    --   }
    -- }

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
    use {
      'rmagatti/auto-session',
      config = config.autosession,
      setup = mappings.autosession,
    }

    -- Register preview - not really needed?
    -- call dein#add('junegunn/vim-peekaboo')
    -- TODO: gennaro-tedesco/nvim-peekup might be better modern alternative

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
    use {
      'weynhamz/vim-plugin-minibufexpl',
      config = config.minibufexpl,
      setup = mappings.minibufexpl,
    }

    -- Command-mode keymaps
    use {
      'vim-utils/vim-husk',
      setup = mappings.husk,
    }

    -- TODO: Make work with LSP or remove
    use {
      'liuchengxu/vista.vim',
      setup = config.vista,
      ft = {
        'python',
      },
    }

    -- TODO: Other python plugins
    -- Use https://github.com/jose-elias-alvarez/null-ls.nvim with linters
    -- Alternative: Can use Yggdroot/indentLine to sort of replace +highlight
    -- Alternatives:
    -- - https://github.com/jeetsukumaran/vim-pythonsense
    --   - Has many more motions
    -- - vim-python-motions
    --   - Slightly more precise
    -- - vim-textobj-user has explicit function/class mappings
    -- Git: Changed map to noremap for easymotion bindings
    -- ,P and ,S - easymotion for top level items
    -- use {
    --   'tweekmonster/braceless.vim',
    --   -- TODO: Test this, kind of weird to do config in setup but thats where
    --   -- the autocmd is needed
    --   config = config.braceless,
    --   ft = {
    --     'python',
    --   },
    -- }

    -- Need to run :UpdateRemotePlugins
    -- TODO: Replace with lsp?
    -- call dein#add('numirias/semshi', {'on_ft': 'python'})
    use {
      'vim-python/python-syntax',
      ft = {
        'python',
      },
    }

    -- TODO: Dig into below
    -- Use pytest.vim instead - only works for pytest, but has way more features
    -- call dein#add('tpope/vim-dispatch')
    -- call dein#add('janko/vim-test')
    -- Alternative: https://github.com/w0rp/python_tools
    -- Alternative: NeoMake
    -- TODO: Enable again?
    -- call dein#add('alfredodeza/pytest.vim', {'on_cmd': 'Pytest'})

    -- ----------End taken directly from old _nvimrc (TODO still: colorizer,
    -- vimwiki, airline, etc)

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
