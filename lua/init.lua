-- Debugging tips
-- vim.inspect(val) will pretty print tables
-- e.g. :lua print(vim.inspect(my_table))
-- TODO: Sign column disappears in edit mode in lua/plugins/sidebar.lua but not
-- here? Maybe try git add
-- \C for case sensitive and \c for case insensitive regex

vim.o.runtimepath = vim.o.runtimepath .. ',~/VimConfig'

vim.opt.autoindent = true
vim.opt.cursorline = true
vim.o.termguicolors = true
-- vim.g.my_test_var = '35a'
--
-- Next:
-- - Sidebar/better buffers view
-- - Make templates work - for full file and local code

-- Notes/to learn:
-- - <C-G> and <C-O> while typing in search - preview match forward/backward
-- TODO: Refactor? Maybe using vimpeccable to clean it up
vim.cmd([[

" Basics {
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

  " set wildmenu
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
    au UIEnter * GuiPopupmenu 0
    au UIEnter * GuiTabline 0
    " Consider SourceCodePro
    au UIEnter * Guifont! Consolas NF:h14
    " au VimEnter * GuiPopupmenu 0
    " au VimEnter * GuiTabline 0
    " " Consider SourceCodePro
    " au VimEnter * Guifont! Consolas NF:h14
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
    " nnoremap <silent> <C-P> :bp<CR>
    " nnoremap <silent> <C-N> :bn<CR>
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
    au FileType ruby,eruby,yaml setl ai sw=2 sts=2 et
    au FileType cpp set ai sw=2 sts=2 et
    au FileType python setl ai sw=4 sts=4 et
    au FileType javascript setl ai sw=4 sts=4 et
    au FileType jinja setl ai sw=4 sts=4 et
    au FileType go setl ai sw=4 sts=4 et

    "au Filetype html,xml,xsl source ~\vimfiles\bundle\closetag.vim
    "autocmd FileType ruby,eruby set omnifunc=rubycomplete#Complete
    " Currently disabled as it tends to lag out on big folders
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
    au BufRead,BufNewFile *.thrift        setfiletype thrift
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

" Search for visually selected text with * # {
  " http://vim.wikia.com/wiki/VimTip171
  let s:save_cpo = &cpo | set cpo&vim
  if !exists('g:VeryLiteral')
    let g:VeryLiteral = 0
  endif

  function! s:VSetSearch(cmd)
    let old_reg = getreg('"')
    let old_regtype = getregtype('"')
    normal! gvy
    if @@ =~? '^[0-9a-z,_]*$' || @@ =~? '^[0-9a-z ,_]*$' && g:VeryLiteral
      let @/ = @@
    else
      let pat = escape(@@, a:cmd.'\')
      if g:VeryLiteral
        let pat = substitute(pat, '\n', '\\n', 'g')
      else
        let pat = substitute(pat, '^\_s\+', '\\s\\+', '')
        let pat = substitute(pat, '\_s\+$', '\\s\\*', '')
        let pat = substitute(pat, '\_s\+', '\\_s\\+', 'g')
      endif
      let @/ = '\V'.pat
    endif
    normal! gV
    call setreg('"', old_reg, old_regtype)
  endfunction

  vnoremap <silent> * :<C-U>call <SID>VSetSearch('/')<CR>/<C-R>/<CR>
  vnoremap <silent> # :<C-U>call <SID>VSetSearch('?')<CR>?<C-R>/<CR>
  vmap <kMultiply> *

  " nmap <silent> <Plug>VLToggle :let g:VeryLiteral = !g:VeryLiteral
  "   \\| echo "VeryLiteral " . (g:VeryLiteral ? "On" : "Off")<CR>
  " if !hasmapto("<Plug>VLToggle")
  "   nmap <unique> <Leader>vl <Plug>VLToggle
  " endif
  let &cpo = s:save_cpo | unlet s:save_cpo
" }

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

" From https://www.reddit.com/r/neovim/comments/suy5j7/highlight_yanked_text/
" Highlight yanked text {
  augroup highlight_yank
  autocmd!
  au TextYankPost * silent! lua vim.highlight.on_yank({higroup="Visual", timeout=500})
  augroup END
" }

if filereadable(expand("~/dotfiles_snap/_nvimrc"))
  source ~/dotfiles_snap/_nvimrc
endif

]])

local function map_key(mode, lhs, rhs, opts)
  -- local options = { noremap=true, silent=true }
  -- if opts then
  --   options = vim.tbl_extend('force', options, opts)
  -- end
  -- vim.api.nvim_set_keymap(mode, lhs, rhs, options)
  vim.api.nvim_set_keymap(mode, lhs, rhs, opts)
end

CURRENT_TREESITTER_CONTEXT = function()
  -- if not packer_plugins["nvim-treesitter"] or packer_plugins["nvim-treesitter"].loaded == false then
  --   return " "
  -- end
  local f = require'nvim-treesitter'.statusline({
    indicator_size = 300,
    type_patterns = {"class", "function", "method", "interface", "type_spec", "table", "if_statement", "for_statement", "for_in_statement"}
  })
  local fun_name = string.format("%s", f) -- convert to string, it may be a empty ts node

  -- print(string.find(fun_name, "vim.NIL"))
  if fun_name == "vim.NIL" then
    return " "
  end
  return " " .. fun_name
end

local config = {}
local mappings = {}
-- Note: Bindings should go in mappings, to support lazy loading. There are some
-- exceptions - like arpeggio and cmp - that need to go in config

config.mason = function()
  require('mason').setup()
end

config.mason_lspconfig = function()
  -- TODO: Consider pairing ruff_lsp with pyright for extra functionality in
  -- python linting
  require('mason-lspconfig').setup({
    -- TODO: Seems likely that this just makes sure we've manually installed
    -- can do that via e.g. :MasonInstall lua_ls
    ensure_installed = {
      'lua_ls',
      'pyright',
      'ruff_lsp',
    },
  })
end

config.cmp = function()
  -- TODO: Fix todos in this file
  require('plugins.cmp')
  vim.cmd([[
    " Note: cmp overrides this one if we bind it. Will be necessary when we
    " remap to cmp's builtin menu - but while using builting pum should be fine
    inoremap <expr> <CR> (pumvisible() ? "\<c-y>\<cr>" : "\<CR>")
    inoremap <expr> <Tab> (pumvisible() ? "\<C-n>" : "\<Tab>")
  ]])
end

config.coq = function()
  require('plugins.coq')
end

config.tokyonight  = function()
  -- vim.cmd("colorscheme tokyonight")
  vim.g.tokyonight_style = "storm"
end

config.kanagawa = function()
  local override_colors = {
    sumiInk0 = "#16161D",
    -- Inactive window background
    sumiInk1b= "#191921",
    -- Main background
    sumiInk1 = "#252525",
    sumiInk2 = "#2A2A37",
    sumiInk3 = "#363646",
    sumiInk4 = "#54546D",

    -- Comment
    fujiGray = "#B2B1A9",
    -- sumiInk0 = "#FF0000",
    -- sumiInk1b = "#00FF00",
    -- sumiInk1 = "#252525",
    -- sumiInk2 = "#0000FF",
    -- sumiInk3 = "#888888",
    -- sumiInk4 = "#111111",
  }
  local override_groups = {}
  require('kanagawa').setup({
      undercurl = true,           -- enable undercurls
      commentStyle = "NONE",
      functionStyle = "NONE",
      -- keywordStyle = "italic",
      -- statementStyle = "bold",
      -- typeStyle = "NONE",
      -- variablebuiltinStyle = "italic",
      specialReturn = true,       -- special highlight for the return keyword
      specialException = true,    -- special highlight for exception handling keywords
      transparent = false,        -- do not set background color
      dimInactive = true,        -- dim inactive window `:h hl-NormalNC`
      globalStatus = false,       -- adjust window separators highlight for laststatus=3
      colors = override_colors,
      overrides = override_groups,
  })
  vim.cmd("colorscheme kanagawa")
end

config.catppuccin = function()
  -- Note: To get this:
  -- :lua print(vim.inspect(require("catppuccin.palettes").get_palette("mocha")))
  -- Output :messages to the buffer
  -- :put = execute('messages')
  local base_colors = {
    base = "#1E1E2E",
    blue = "#89B4FA",
    crust = "#11111B",
    flamingo = "#F2CDCD",
    green = "#A6E3A1",
    lavender = "#B4BEFE",
    mantle = "#181825",
    maroon = "#EBA0AC",
    mauve = "#CBA6F7",
    overlay0 = "#6C7086",
    overlay1 = "#7F849C",
    overlay2 = "#9399B2",
    peach = "#FAB387",
    pink = "#F5C2E7",
    red = "#F38BA8",
    rosewater = "#F5E0DC",
    sapphire = "#74C7EC",
    sky = "#89DCEB",
    subtext0 = "#A6ADC8",
    subtext1 = "#BAC2DE",
    surface0 = "#313244",
    surface1 = "#45475A",
    surface2 = "#585B70",
    teal = "#94E2D5",
    text = "#CDD6F4",
    yellow = "#F9E2AF"
  }

  require('catppuccin').setup({
    dim_inactive = {
      enabled = true,
      percentage = 0.1,
    },
    -- TODO: Consider no italic
    color_overrides = {
      mocha = {
        base = "#292929",
      },
    },
    integrations = {
      cmp = true,
      illuminate = true,
      telescope = true,
    }
  })
  vim.cmd.colorscheme('catppuccin')
end

config.illuminate = function()
  -- Colorscheme overrides this despite the highlight! - need to move to after
  -- the 'colorscheme' command if needed. Currently (kanagawa), this isn't
  -- needed
  -- Note: Colorscheme seems to override. It's possible this is just onedark,
  -- but for now, moved to just after the 'colorscheme' command
  -- vim.cmd([[
  -- " autocmd ColorScheme * highlight! link Hlargs TSParameter
  -- autocmd ColorScheme * highlight! LspReferenceText guibg=#FF0000
  -- autocmd ColorScheme * highlight! LspReferenceWrite guibg=#554040
  -- autocmd ColorScheme * highlight! LspReferenceRead guibg=#453030
  -- ]])

  -- vim.api.nvim_set_keymap('n', '<a-n>', '<cmd>lua require("illuminate").next_reference{wrap=true}<cr>', {noremap=true})
  -- vim.api.nvim_set_keymap('n', '<a-p>', '<cmd>lua require("illuminate").next_reference{reverse=true,wrap=true}<cr>', {noremap=true})
  require('illuminate').configure({
    min_count_to_highlight = 2,
  })
end

config.telescope = function()
  require('plugins.telescope')
end

mappings.telescope = function()
  -- TODO: Consider more from e.g. LazyVim - live_grep from local folder, marks,
  -- etc
  vim.keymap.set('n', '<Space>ff', function ()
    -- In theory can do this by vim.fn.expand('%:h'), seems to fail
    local path = require('plenary.path')
    local root = tostring(path:new(vim.fn.expand('%')):parent())
    return require('telescope.builtin').find_files({cwd = root})
  end)
  vim.cmd([[
  " nnoremap <Space>ff <cmd>lua require('telescope.builtin').find_files({cwd = })<CR>
  nnoremap <Space>fv :Telescope find_files<CR>
  nnoremap <Space>fg :Telescope live_grep<CR>
  nnoremap <Space>fh :Telescope help_tags<CR>
  nnoremap <Space>fb :Telescope buffers<CR>

  nnoremap <Space>js :Telescope lsp_document_symbols<CR>
  nnoremap <Space>jr :Telescope lsp_references<CR>
  " nnoremap <Space>jd :Telescope lsp_document_diagnostics<CR>
  nnoremap <Space>jd :Telescope lsp_definitions<CR>
  ]])
  -- TODO: Consider which-key - good example at
  -- https://github.com/nuxshed/dotfiles/blob/main/config/nvim/lua/plugins/telescope.lua
end

config.arpeggio = function()
  vim.fn['arpeggio#map']('i', '', 0, 'jk', '<Esc>')
  vim.fn['arpeggio#map']('c', '', 0, 'jk', '<C-c>')
  vim.fn['arpeggio#map']('v', '', 0, 'jk', '<Esc>')
  vim.fn['arpeggio#map']('o', '', 0, 'jk', '<Esc>')
  vim.fn['arpeggio#map']('s', '', 0, 'jk', '<Esc>')
end

config.lualine = function()
  require('lualine').setup({
    options = {
      theme = "catppuccin",
      icons_enabled = true,
      component_separators = { left = '', right = ''},
      section_separators = { left = '', right = ''},
      ignore_focus = {},
      always_divide_middle = true,
      globalstatus = true,
      refresh = {
        statusline = 1000,
      },
    },
    sections = {
      lualine_a = {'mode'},
      lualine_b = {'branch', 'diff', 'diagnostics'},
      lualine_c = {'filename'},
      -- lualine_x = {'encoding', 'fileformat', 'filetype'},
      lualine_x = {'filetype'},
      -- lualine_x = {},
      lualine_y = {'progress'},
      -- lualine_y = {'filetype', 'progress'},
      lualine_z = {'location'},
    },
    inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = {'filename'},
      lualine_x = {'location'},
      lualine_y = {},
      lualine_z = {},
    },
  })
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
  require('nvim-treesitter.configs').setup({
    ensure_installed = {
      'lua',
      'python',
      'vim',
    },
    highlight = {
      enable = true,
      use_languagetree = true,
    },
    -- Note: Part of matchup plugin
    matchup = {
      enable = true,
    },
    -- TODO: Consider also other suggestions in comments of
    -- https://www.reddit.com/r/neovim/comments/r10llx/the_most_amazing_builtin_feature_nobody_ever/
    -- nvim-treehopper - hop.nvim for treesitter nodes
    -- RRethy/nvim-treesitter-textsubjects - another option for incremental
    -- selection
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = '<CR>',
        scope_incremental = '<CR>',
        node_incremental = '<TAB>',
        node_decremental = '<S-TAB>',
      },
    },
  })
end

config.hlargs = function()
  require('hlargs').setup()
  vim.cmd [[autocmd ColorScheme * highlight! link Hlargs TSParameter]]
end

-- TODO: Consider also utilyre/barbecue.nvim - winbar version
-- Seems a bit smoother/heavier weight, but has nice pieces - can show even
-- below function level, uses winbar so more consistent
config.treesitter_context = function()
  require('treesitter-context').setup()
end

config.treesitter_textobjects = function()
  require'nvim-treesitter.configs'.setup {
    textobjects = {
      select = {
        enable = true,
        lookahead = true,
        keymaps = {
          -- You can use the capture groups defined in textobjects.scm
          ['af'] = { query = '@function.outer', desc = 'Select outer part of a function' },
          ['if'] = { query = '@function.inner', desc = 'Select inner part of a function' },
          ['ac'] = { query = '@class.outer', desc = 'Select outer part of a class' },
          ['ic'] = { query = '@class.inner', desc = 'Select inner part of a class' },
          ['aC'] = { query = '@comment.outer', desc = 'Select outer part of a comment' },
          ['iC'] = { query = '@comment.inner', desc = 'Select inner part of a comment' },
          ['a,'] = { query = '@parameter.outer', desc = 'Select outer part of a parameter' },
          ['i,'] = { query = '@parameter.inner', desc = 'Select inner part of a parameter' },
          -- You can also use captures from other query groups like `locals.scm`
          -- ['as'] = { query = '@scope', query_group = 'locals', desc = 'Select language scope' },
        },
        selection_modes = {
          ['@parameter.outer'] = 'v',
          ['@function.outer'] = 'V',
          ['@class.outer'] = 'V',
        },
      },
      swap = {
        enable = true,
        swap_next = {
          [',>'] = '@parameter.inner',
        },
        swap_previous = {
          [',<'] = '@parameter.inner',
        },
      },
    },
  }
end

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

-- Notes:
-- - Write snippets more easily with https://snippet-generator.app/
-- - Find user snippets at
-- https://code.visualstudio.com/docs/editor/userdefinedsnippets (marketplace)
config.luasnip = function()
  local luasnip = require('luasnip')

  -- Hack - this is what LuaSnip uses to find the friendly-snippets folder, so
  -- we just copy the code
  local function get_snippet_rtp()
    return vim.tbl_map(function(itm)
      return vim.fn.fnamemodify(itm, ":h")
    end, vim.api.nvim_get_runtime_file("package.json", true))
  end

  luasnip.config.set_config {
    history = true,
    updateevents = 'TextChanged,TextChangedI',
  }
  local paths = get_snippet_rtp()
  table.insert(paths, "~/VimConfig/snippets_luasnip")
  require("luasnip.loaders.from_vscode").lazy_load({
    paths = paths,
  })

  vim.cmd([[
  snoremap <silent> <C-L> <cmd>lua require('luasnip').jump(1)<CR>
  snoremap <silent> <C-H> <cmd>lua require('luasnip').jump(-1)<CR>
  " inoremap <silent> <C-L> <cmd>lua require('luasnip').jump(1)<CR>
  imap <silent><expr> <C-L> luasnip#expand_or_jumpable() ? '<Plug>luasnip-expand-or-jump' : '<C-L>' 
  inoremap <silent> <C-H> <cmd>lua require('luasnip').jump(-1)<CR>
  ]])
end

mappings.trouble = function()
  vim.cmd([[
  nnoremap <Space>tt <cmd>TroubleToggle<CR>
  nnoremap <Space>tw <cmd>TroubleToggle workspace_diagnostics<CR>
  nnoremap <Space>tf <cmd>TroubleToggle document_diagnostics<CR>
  " nnoremap <Space>tq <cmd>TroubleToggle quickfix<CR>
  " nnoremap <Space>tl <cmd>TroubleToggle loclist<CR>
  nnoremap <Space>tr <cmd>TroubleToggle lsp_references<CR>
  ]])
end

config.trouble = function()
  require('trouble').setup({
  })
end

mappings.sidebar = function()
  vim.cmd([[
  nnoremap <F4> <cmd>SidebarNvimToggle<CR>
  ]])
  -- Doesn't work - likely the function dissappears when mappings is processed
  -- by packer
  -- map_key('n', '<C-N>', "<cmd>lua require('plugins.sidebar').next_buf()<CR>", {})
  -- map_key('n', '<C-P>', "<cmd>lua require('plugins.sidebar').prev_buf()<CR>", {})
  vim.api.nvim_set_keymap('n', '<C-P>', "<cmd>lua require('plugins.sidebar').prev_buf()<CR>", {})
  vim.api.nvim_set_keymap('n', '<C-N>', "<cmd>lua require('plugins.sidebar').next_buf()<CR>", {})
  vim.api.nvim_set_keymap('n', '<leader>d', "<cmd>lua require('plugins.sidebar').delete_buf()<CR>", {})
end

config.sidebar = function()
  require('plugins.sidebar')
  -- local sidebar = require('plugins.sidebar')
  -- Note: Trying to require sidebar in mappings breaks since it's too early
end

mappings.minibufexpl = function()
  -- vim.cmd([[
  --   let g:miniBufExplorerAutoStart = 0
  --   if g:is_tabbed == 1
  --     nnoremap <Leader>d :bd<CR>
  --   else
  --     nnoremap <Leader>d :MBEbd<CR>
  --   endif
  -- ]])
end

config.minibufexpl = function()
  vim.cmd([[
    if g:is_tabbed == 1
      let g:miniBufExplorerAutoStart = 0
    else
      let g:miniBufExplVSplit = 30   " Column width in chars
      let g:miniBufExplBRSplit = 0   " Split on left

      " let g:miniBufExplorerAutoStart = 1
      let g:miniBufExplorerAutoStart = 0
      let g:miniBufExplBuffersNeeded = 0
      let g:miniBufExplShowBufNumbers = 0
      let g:miniBufExplCycleArround = 1
    endif
  ]])
end

mappings.autosession = function()
  -- Note: Windows sessions in C:\Users\jason\AppData\Local\nvim-data\sessions
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

-- mappings.packer = function()
--   vim.cmd([[
--     nnoremap <Space>pi :PackerInstall<CR>
--     nnoremap <Space>pc :PackerCompile<CR>
--     ]])
-- end
-- -- TODO: Fix - see comment in packer config
-- mappings.packer()

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

mappings.spider = function()
  -- vim.keymap.set({"n", "o", "x"}, "w", "<cmd>lua require('spider').motion('w')<CR>", { desc = "Spider-w" })
  -- vim.keymap.set({"n", "o", "x"}, "e", "<cmd>lua require('spider').motion('e')<CR>", { desc = "Spider-e" })
  -- vim.keymap.set({"n", "o", "x"}, "b", "<cmd>lua require('spider').motion('b')<CR>", { desc = "Spider-b" })
  -- vim.keymap.set({"n", "o", "x"}, "ge", "<cmd>lua require('spider').motion('ge')<CR>", { desc = "Spider-ge" })
  vim.keymap.set({"n", "o", "x"}, "<C-.>", "<cmd>lua require('spider').motion('w')<CR>", { desc = "Spider-w" })
  vim.keymap.set({"n", "o", "x"}, "<C-,>", "<cmd>lua require('spider').motion('b')<CR>", { desc = "Spider-b" })
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

-- 2023-05 - This issue may be fixed, but seems still a bit worse at e.g. adding
-- curly brace then newline (wrong indent). Should be fixable with config
-- Note: Lexima handles repeat better - this handles single line repeats well,
-- though multiline can get glitchy
-- TODO: Consider using this instead - has much more power
-- Note: There's an issue with <CR> with the preview menu up - repro:
-- <text to trigger autocomplete><c-n><cr> - undo will break and add an extra
-- line. Maybe autopairs, so try lexima
-- Note: Above issue is probably braceless with <cr> mapped
-- TODO: Get this to work with newline (e.g. {<cr>)
config.autopairs = function()
  -- require('nvim-autopairs').setup({
  --   map_cr = false,
  -- })
  require('nvim-autopairs').setup()

  -- Add `(` after using cmp
  -- TODO: Figure out an elegant way to mix this with multiple completion
  -- sources - cmp and coq
  local cmp_autopairs = require('nvim-autopairs.completion.cmp')
  local cmp = require('cmp')
  cmp.event:on(
    'confirm_done',
    cmp_autopairs.on_confirm_done({
      map_char = { tex = '' }
    }))
end

config.lexima = function()
  vim.g.lexima_enable_basic_rules = 1
  vim.g.lexima_enable_newline_rules = 1
  vim.g.lexima_enable_endwise_rules = 1
  vim.g.lexima_accept_pum_with_enter = 0
end

config.comment = function()
  require('Comment').setup()
end

config.hop = function()
  require('hop').setup()
  -- TODO: Add mappings for e.g. line/word/operator mode - like easymotion ,w
  -- TODO: Consider MW variant (multiple window)
  vim.fn['arpeggio#map']('n', '', 0, 'we', ':HopChar2<CR>')
  vim.fn['arpeggio#map']('v', '', 0, 'we', '<cmd>HopChar2<CR>')
end

-- Todo: Intersperse config and plugins
-- Config for lazy.nvim plugins
local plugins = {}
-- TODO: How to manage/update lazy itself?

local add_plugin = function(spec)
  table.insert(plugins, spec)
end

add_plugin {'nvim-lua/plenary.nvim'}

-- For easier colorscheme configuration, try
-- https://github.com/norcalli/nvim-colorizer.lua

-- Treesitter supported schemes -
-- https://github.com/rockerBOO/awesome-neovim#color
-- Lots of plugin support - https://github.com/folke/tokyonight.nvim
-- Aid to setting colors - https://github.com/rktjmp/lush.nvim
-- Tried colorschemes
--   'arcticicestudio/nord-vim',
--   'rafamadriz/neon',
--   'metalelf0/jellybeans-nvim',
--   'RRethy/nvim-base16',
--   'mhartington/oceanic-next',
--   'sainnhe/edge',
--   -- Not bad, tinted bg, hard to tell print vs self._bar colors
--   'sainnhe/sonokai',
--   'tomasiser/vim-code-dark',
--   'projekt0n/github-nvim-theme',

-- Rejected colorschemes:
-- 'navarasu/onedark.nvim', -- Ok, neon slightly better
-- 'EdenEast/nightfox.nvim', -- Colors too light - intended for much darker
-- background
-- 'novakne/kosmikoa.nvim', -- Colors ok, aggressive italics, bad bg
-- 'Th3Whit3Wolf/space-nvim', -- Also lots of italics
-- 'glepnir/zephyr-nvim',
-- 'Th3Whit3Wolf/one-nvim', -- Need to fix background, maybe worthwhile?
-- 'mhartington/oceanic-next', -- Need to fix background, maybe worthwhile?
-- 'Th3Whit3Wolf/onebuddy',
-- 'tomasiser/vim-code-dark', -- A little too dark, can probably adjust bg
-- 'sainnhe/edge',  -- Not as good as sonokai
-- 'ellisonleao/gruvbox.nvim', -- Ok potentially
-- 'ishan9299/nvim-solarized-lua', -- Even with overrides to colors, still
-- too low contrast

add_plugin {
  'catppuccin/nvim',
  name = 'catppuccin',
  config = config.catppuccin,
  lazy = false,
  priority = 1000,
}

add_plugin {
  'norcalli/nvim-colorizer.lua',
  cmd = 'ColorizerToggle',
}

-- add_plugin {
--   'folke/tokyonight.nvim',
--   config = config.tokyonight,
-- }

-- add_plugin {
--   'rebelot/kanagawa.nvim',
--   config = config.kanagawa,
-- }

add_plugin {
  'nvim-telescope/telescope.nvim',
  cmd = 'Telescope',
  config = config.telescope,
  init = mappings.telescope,
  module = 'telescope',
  dependencies = {
    {'nvim-lua/plenary.nvim'},
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'make',
    },
  },
}

-- Note: For just esc, can use
-- https://github.com/max397574/better-escape.nvim
add_plugin {
  'kana/vim-arpeggio',
  config = config.arpeggio,
  lazy = false,
  -- Other dependencies use this to map keys. Packer does two pass, but lazy
  -- does one pass, so need to ensure this is first
  priority = 1000,
}

-- Lua fork has extra colors
-- add_plugin 'kyazdani42/nvim-web-devicons'
add_plugin 'nvim-tree/nvim-web-devicons'

add_plugin {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = config.lualine,
}

-- TODO: Fix - control color, make vertical spacing work - probably the font
add_plugin {
  'lukas-reineke/indent-blankline.nvim',
  -- TODO: Debug - doesn't work with this
  -- event = 'BufRead',
  config = config.blankline,
}

-- TODO: Only on command
-- add_plugin {
--   'norcalli/nvim-colorizer.lua',
--   event = 'BufRead',
--   config = override_req('nvim_colorizer', '(plugins.configs.others).colorizer()'),
-- }

add_plugin {
    'nvim-treesitter/nvim-treesitter',
    run = function()
        local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
        ts_update()
    end,
    config = config.treesitter,
}

add_plugin {
  'm-demare/hlargs.nvim',
  dependencies = { 'nvim-treesitter/nvim-treesitter' },
  config = config.hlargs,
}

add_plugin {
  'nvim-treesitter/nvim-treesitter-context',
  dependencies = { 'nvim-treesitter/nvim-treesitter' },
  config = config.treesitter_context,
}

add_plugin {
  'nvim-treesitter/nvim-treesitter-textobjects',
  dependencies = { 'nvim-treesitter' },
  config = config.treesitter_textobjects,
}

-- TODO: Fix
-- add_plugin {
--   'lewis6991/gitsigns.nvim',
--   config = override_req('gitsigns', 'plugins.configs.gitsigns'),
--   init = function()
--     require('core.utils').packer_lazy_load 'gitsigns.nvim'
--   end,
-- }

add_plugin {
  'williamboman/mason.nvim',
  -- run = ":MasonUpdate",
  config = config.mason,
}

add_plugin {
  'williamboman/mason-lspconfig.nvim',
  dependencies = {
    {'williamboman/mason.nvim'},
  },
  config = config.mason_lspconfig,
}

add_plugin {
  'neovim/nvim-lspconfig',
  -- TODO: Coq needs to override this for some reason?
  -- TODO: Same with cmp
  -- TODO: Find a cleaner way to handle this
  -- config = function() require('plugins.lspconfig') end,
  dependencies = {
    {'williamboman/mason-lspconfig.nvim'},
  },
}

-- TODO: Decide
local completionEngine = 'cmp'
if completionEngine == 'coq' then
  add_plugin {
    'ms-jpq/coq_nvim',
    branch = 'coq',
    config = config.coq,
    dependencies = {
      {'neovim/nvim-lspconfig'},
    },
  }
elseif completionEngine == 'cmp' then
  add_plugin {
    'rafamadriz/friendly-snippets',
    -- event = 'InsertEnter',
  }

  -- Other options: https://github.com/rockerBOO/awesome-neovim#cursorline
  -- Highlight current word
  -- Note: Has config plus attach script in cmp
  -- Note: Causes issues with really long args (see vim.cmd at the start of
  -- this file)
  add_plugin {
    -- Note: Config is within lsp config
    -- TODO: Add proper hooks to keep configs independent
    'RRethy/vim-illuminate',
    config = config.illuminate,
  }

  -- TODO: Consider other plugins
  -- https://github.com/hrsh7th/nvim-cmp/wiki/List-of-sources - esp calc,
  -- treesitter, lsp-signature-help - latter will require enabling native
  -- menu
  -- Consider also dadbod - will require custom bq extension though
  -- TODO: Spelling correction - https://github.com/f3fora/cmp-spell and
  -- underlines for misspellings
  add_plugin {
    'hrsh7th/nvim-cmp',
    config = config.cmp,
    dependencies = {
      {'hrsh7th/cmp-buffer'},
      {'hrsh7th/cmp-nvim-lsp'},
      {'hrsh7th/cmp-path'},
      {'hrsh7th/cmp-nvim-lua'},
      {'hrsh7th/cmp-cmdline'},
      {'hrsh7th/cmp-nvim-lsp-document-symbol'},
      {'max397574/cmp-greek'},
      {'hrsh7th/cmp-nvim-lsp-signature-help'},
      {'ray-x/cmp-treesitter'},
      {'L3MON4D3/LuaSnip'},
    },
  }

  -- TODO: Try again - previously overlapped with nvim-cmp popup, but that
  -- may be fixed with native menu
  -- Take config from the author -
  -- https://github.com/ray-x/nvim/blob/master/lua/modules/completion/plugins.lua
  -- add_plugin {
  --   'ray-x/lsp_signature.nvim',
  --   dependencies = {
  --     'nvim-cmp',
  --     'nvim-lspconfig',
  --   },
  --   config = config.lsp_signature,
  --   dependencies = {
  --     {'neovim/nvim-lspconfig'},
  --   },
  -- }

  -- Other snippet plugins. Most popular as of 2022-04:
  -- - https://github.com/SirVer/ultisnips
  -- - https://github.com/hrsh7th/vim-vsnip - likely best integration with
  -- cmp, but still vimscript
  -- - https://github.com/norcalli/snippets.nvim
  add_plugin {
    'L3MON4D3/LuaSnip',
    dependencies = {
      'friendly-snippets',
    },
    -- dependencies = {
    --   'nvim-cmp',
    -- },
    config = config.luasnip,
  }

  add_plugin {
    'saadparwaiz1/cmp_luasnip',
    dependencies = {
      'LuaSnip',
      'nvim-cmp',
    },
  }

  add_plugin {
    'hrsh7th/cmp-nvim-lua',
    dependencies = {
      'LuaSnip',
      'nvim-cmp',
    },
  }
else
  error('Invalid completion engine ' .. completionEngine)
end

add_plugin {
  'folke/trouble.nvim',
  dependencies = 'nvim-tree/nvim-web-devicons',
  init = mappings.trouble,
  config = config.trouble,
}

add_plugin {
  'sidebar-nvim/sidebar.nvim',
  init = mappings.sidebar,
  config = config.sidebar,
}

-- TODO: Doesn't let repeat with newlines work
-- TODO: Use endwise functionality to auto-end language constructs
-- TODO: Adding newline inside a pair works poorly
-- TODO: Dig into their event attachment for cmp - can do any action after
-- accepting a completion
-- add_plugin {
--   'windwp/nvim-autopairs',
--   dependencies = {
--     'nvim-cmp',
--   },
--   config = config.autopairs,
-- }

-- TODO: Consider also ending html/xml -
-- https://www.reddit.com/r/neovim/comments/mylhuw/is_there_a_treesitter_based_autopairs_plugin/
-- - windwp/nvim-ts-autotag
-- TODO: Try tmsvg/pear-tree - may support dot-repeat even more effectively
-- Though relatively unmaintained
add_plugin {
  'cohama/lexima.vim',
  init = config.lexima,
}

add_plugin {
  'andymass/vim-matchup',
  -- Note: Configured in treesitter - need to edit that config instead
}

-- Nice for per-language mappings, but can't get it to stop adding a space
-- after comment lines
-- tpope/vim-commentary doesn't have the option either
-- add_plugin {
--   'terrortylor/nvim-comment',
--   -- cmd = {'CommentToggle', 'CommentOperator'},
--   config = config.comment,
--   init = mappings.comment,
--   event = 'BufRead',
-- }
-- TODO: Learn some of the extra mappings
add_plugin {
  'numToStr/Comment.nvim',
  config = config.comment,
}

-- ----------Taken directly from old _nvimrc

-- Alternative: AndrewRadev/splitjoin.vim - more popular, but doesn't seem to
-- indent quite correctly
add_plugin {
  'FooSoft/vim-argwrap',
  cmd = 'ArgWrap',
  config = config.argwrap,
  init = mappings.argwrap,
}

-- -- TODO: Needed? LSP may do format
-- -- TODO: Replace?
-- -- call dein#add('sbdchd/neoformat')
--
-- -- TODO: Find treesitter/lua replacements
-- -- Text objects
-- -- e.g. vaf, vac (rebound below to vaC, conflicts with tcomment select comment)
-- add_plugin {
--   'bps/vim-textobj-python',
--   config = config.textobj_python,
--   ft = {
--     'python',
--   },
--   dependencies = {
--     {'kana/vim-textobj-user'},
--   }
-- }
-- -- Alternative: https://github.com/vim-scripts/argtextobj.vim
-- -- Older: call dein#add('vim-scripts/Parameter-Text-Objects')
-- -- e.g. vi, - select parameter
-- add_plugin {
--   'sgur/vim-textobj-parameter',
--   dependencies = {
--     {'kana/vim-textobj-user'},
--   }
-- }
-- -- e.g. vie - ie trims whitespace, ae selects entire
add_plugin {
  'kana/vim-textobj-entire',
  dependencies = {
    {'kana/vim-textobj-user'},
  }
}
-- -- e.g. viv - camelCase or under_score part
add_plugin {
  'Julian/vim-textobj-variable-segment',
  dependencies = {
    {'kana/vim-textobj-user'},
  }
}
-- -- e.g. vam - method, vaM - method chain
add_plugin {
  'thalesmello/vim-textobj-methodcall',
  dependencies = {
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
add_plugin {
  'chrisgrieser/nvim-spider',
  lazy = true,
  init = mappings.spider,
}

-- Works ok, but requires python2
-- call dein#add('vim-scripts/swap-parameters')
-- Way better than swap-parameters, but bindings conflict with tcomment (net:
-- get rid of tcomment)
-- g<, g> to move param, gs to enter swap mode
add_plugin 'machakann/vim-swap'

-- Alternative: airblade/vim-gitgutter
-- e.g. [c, ]c, [C, ]C - jump to chunk
-- e.g. vig - select git chunk (mapped below)
-- TODO: lewis6991/gitsigns.nvim
add_plugin {
  'mhinz/vim-signify',
  init = mappings.signify,
  config = config.signify,
}
add_plugin 'tpope/vim-fugitive'

add_plugin {
  'rhysd/git-messenger.vim',
  init = config.git_messenger,
  cmd = 'GitMessenger',
  keys = '<Plug>(git-messenger)',
}

-- Alternative: undotree
-- Alternative: gundo
-- Forks and extends gundo
add_plugin {
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
add_plugin 'tpope/vim-abolish'

-- Options:
-- - easymotion/sneak - older and vim focused
add_plugin {
  'phaazon/hop.nvim',
  branch = 'v2',
  config = config.hop,
}
-- - lightspeed.nvim - seems most active, supports multi-window seek
-- Issues:
-- - No way to just seek two characters globally - really wants to operate
--  from cursor
-- - A little weird to get used to. Might be worth it if not for the above
--  issue. E.g. auto jumps early if you enter a unique first char, timeouts
--  on repeated jumps for f are REALLY low, etc
-- add_plugin {
--   'ggandor/lightspeed.nvim',
--   -- Config also does mappings, since these use arpeggio
--   -- TODO: Use autocommands for the mappings instead
--   config = config.lightspeed,
--   dependencies = {
--     {'kana/vim-arpeggio'},
--   }
-- }

-- TODO: Replace
-- call dein#add('hynek/vim-python-pep8-indent', {'on_ft': 'python'})
-- call dein#add('tpope/vim-ragtag')
add_plugin 'tpope/vim-repeat'
-- TODO: Consider machakann/vim-sandwich
add_plugin 'tpope/vim-surround'
add_plugin 'tpope/vim-unimpaired'

-- TODO: Session manager
-- -- Alternative: tpope/vim-obsession
-- call dein#add('xolox/vim-misc')
-- call dein#add('xolox/vim-session')
add_plugin {
  'rmagatti/auto-session',
  config = config.autosession,
  init = mappings.autosession,
}

-- Register preview - not really needed?
-- call dein#add('junegunn/vim-peekaboo')
-- TODO: gennaro-tedesco/nvim-peekup might be better modern alternative

-- TODO: Note: Disabled for now - use sidebar instead
-- -- Show open buffers, vertically
-- -- Other options: horizontal tagbar
-- -- vim-buftabline, vem-tabline
-- -- Has a bug when deleting unknown buffers (e.g. :Pytest file -s)
-- -- Fix: Add dictionary guard !has_key(s:bufPathDict, bufnr) to
-- -- BuildBufferPathSignDict
-- -- weynhamz is slightly newer
-- -- call dein#add('fholgado/minibufexpl.vim')
-- call dein#add('weynhamz/vim-plugin-minibufexpl')
-- add_plugin {
--   'weynhamz/vim-plugin-minibufexpl',
--   config = config.minibufexpl,
--   init = mappings.minibufexpl,
-- }

-- Command-mode keymaps
add_plugin {
  'vim-utils/vim-husk',
  init = mappings.husk,
}

-- TODO: Make work with LSP or remove
add_plugin {
  'liuchengxu/vista.vim',
  init = config.vista,
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
-- add_plugin {
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
add_plugin {
  'vim-python/python-syntax',
  ft = {
    'python',
  },
}

local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
require('lazy').setup(plugins, {
  performance = {
    rtp = {
      -- TODO: This is desirable behavior in general but breaks nvim-qt on
      -- windows - which depends on this to add Gui comments. Look into manually
      -- re-adding just the one file
      reset = false,
    },
  },
})

--[[
TODOs:
- Telescope vimwiki - https://www.reddit.com/r/neovim/comments/pyvelg/telescopevimwikinvim_just_a_quick_way_to_open_up/

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
-- - https://github.com/jose-elias-alvarez/null-ls.nvim - Add external lint
-- - kyazdani42/nvim-tree.lua or some other tree plugin (nvchad config)
-- - lspkind - from nvim-cmp, better icons
