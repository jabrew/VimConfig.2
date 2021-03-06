set rtp+=~/VimConfig

if has("win32")
  let g:use_ycm = 1
  " Temporary: jedi doesn't load correctly without this in windows (and maybe
  " homebrew python). Needs to be before the runtimepath updates below
  python3 import sys; sys.executable = 'C:/Programs/Python/Python37/python.exe'
  python3 sys.path.append('C:/Users/Brew/Anaconda3/Lib')
  python3 sys.path.append('C:/Users/Brew/Anaconda3/Lib/site-packages')
else
  let g:use_ycm = 1
endif

" Vundle {
  set nocompatible              " be iMproved, required
  filetype off                  " required

  " set the runtime path to include Vundle and initialize
  set rtp+=~/.vim/bundle/Vundle.vim
  call vundle#begin()
  " alternatively, pass a path where Vundle should install plugins
  "call vundle#begin('~/some/path/here')

  " let Vundle manage Vundle, required
  Plugin 'gmarik/Vundle.vim'

  " Newer: jiangmiao/auto-pairs
  Plugin 'vim-scripts/Auto-Pairs'
  Plugin 'kana/vim-arpeggio'

  Plugin 'kien/ctrlp.vim'
  Plugin 'sjl/gundo.vim'
  " Alternative: https://github.com/vim-scripts/argtextobj.vim
  Plugin 'vim-scripts/Parameter-Text-Objects'
  Plugin 'vim-scripts/swap-parameters'
  Plugin 'scrooloose/syntastic'
  Plugin 'tomtom/tcomment_vim'
  Plugin 'tpope/vim-abolish'
  Plugin 'Lokaltog/vim-easymotion'
  Plugin 'hynek/vim-python-pep8-indent'
  " Plugin 'google/yapf', { 'rtp': 'plugins/vim' }
  Plugin 'tpope/vim-ragtag'
  Plugin 'tpope/vim-repeat'
  Plugin 'tpope/vim-surround'
  Plugin 'tpope/vim-unimpaired'
  Plugin 'tmhedberg/matchit'

  Plugin 'fholgado/minibufexpl.vim.git'

  Plugin 'mileszs/ack.vim'

  " Python
  " Plugin 'ivanov/vim-ipython'
  Plugin 'davidhalter/jedi-vim'
  Plugin 'okcompute/vim-python-motions'

  " Devdocs
  " Inline with vim, but seems to only search language docs
  " Plugin 'thomasthune/devdocsbuf'
  " Plugin 'rhysd/devdocs.vim'

  " rsi is simpler, but works in a few more modes
  Plugin 'vim-utils/vim-husk'

  " Text objects
  Plugin 'kana/vim-textobj-user'
  Plugin 'thalesmello/vim-textobj-methodcall'
  Plugin 'wellle/targets.vim'
  Plugin 'bkad/CamelCaseMotion'

  " Syntax
  " Jinja2 is about as close as we can get to nunjucks
  " Plugin 'Glench/Vim-Jinja2-Syntax'
  Plugin 'solarnz/thrift.vim'

  if !g:use_ycm
    " Disabled (doesn't work 2018-01-31)
    " if !has('nvim')
    "   Plugin 'roxma/vim-hug-neovim-rpc'
    " endif
    " Plugin 'roxma/nvim-completion-manager'

    if has('nvim')
      Plugin 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
    else
      Plugin 'Shougo/deoplete.nvim'
      Plugin 'roxma/nvim-yarp'
      Plugin 'roxma/vim-hug-neovim-rpc'
    endif
    Plugin 'zchee/deoplete-jedi'
  endif

  " Wiki
  Plugin 'vimwiki/vimwiki'

  " Colors
  Plugin 'altercation/vim-colors-solarized'
  Plugin 'd11wtq/tomorrow-theme-vim'
  Plugin 'jnurmine/Zenburn'
  Plugin 'jonathanfilip/vim-lucius'
  Plugin 'nanotech/jellybeans.vim'
  Plugin 'tomasr/molokai'

  " Also consider lightline/airline theme
  Plugin 'fneu/breezy'

  " Rejected colors
  " Plugin '29decibel/codeschool-vim-theme'
  " Plugin 'blueshirts/darcula'
  " Plugin 'jpo/vim-railscasts-theme'
  " Plugin 'morhetz/gruvbox'
  " Plugin 'sickill/vim-monokai'
  " Plugin 'vim-scripts/darktango.vim'
  " Plugin 'vim-scripts/twilight'
  " Plugin 'w0ng/vim-hybrid'

  " Colors to try
  " Plugin 'joshdick/onedark.vim'

"  " The following are examples of different formats supported.
"  " Keep Plugin commands between vundle#begin/end.
"  " plugin on GitHub repo
"  Plugin 'tpope/vim-fugitive'
"  " plugin from http://vim-scripts.org/vim/scripts.html
"  Plugin 'L9'
"  " Git plugin not hosted on GitHub
"  Plugin 'git://git.wincent.com/command-t.git'
"  " git repos on your local machine (i.e. when working on your own plugin)
"  Plugin 'file:///home/gmarik/path/to/plugin'
"  " The sparkup vim script is in a subdirectory of this repo called vim.
"  " Pass the path to set the runtimepath properly.
"  Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
"  " Avoid a name conflict with L9
"  Plugin 'user/L9', {'name': 'newL9'}

  " All of your Plugins must be added before the following line
  call vundle#end()            " required
  filetype plugin indent on    " required
  " To ignore plugin indent changes, instead use:
  "filetype plugin on
  "
  " Brief help
  " :PluginList       - lists configured plugins
  " :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
  " :PluginSearch foo - searches for foo; append `!` to refresh local cache
  " :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
  "
  " see :h vundle for more details or wiki for FAQ
  " Put your non-Plugin stuff after this line
" }
if g:use_ycm
  set rtp+=~/.vim/manual-bundle/YouCompleteMe
endif

" Colors {
  " let g:molokai_original = 1
  " colorscheme molokai

  " let g:solarized_termcolors = 256
  " colorscheme solarized

  if has('gui_running')
    " colorscheme desert
    colorscheme jbrewer_desert
  else
    " colorscheme darcula
    colorscheme jbrewer_desert
  end
" }

" Basics {
  set nocompatible
  set ruler
  set ignorecase
  set smartcase
  set incsearch
  set hls

  " TODO: Consider 'showfulltag' for autocomplete

  set showcmd
  set wildmode=list:longest,full

  if has('win32')
    set lcs=tab:�\ ,trail:�,extends:#,nbsp:.
  else
    set lcs=tab:»\ ,trail:·,extends:#,nbsp:.
  endif
  set list

  set number

  set wildmenu
  set so=5
  set lz

  set vb t_vb=

  set formatoptions=croqln
  " set cursorline

  " From http://ksjoberg.com/vim-esckeys.html , this should help the issue
  " where pushing esc takes a while to take effect
  set noesckeys

  " To set up vimwiki:
  " cd /Applications
  " cp -r MacVim.app/ VimWiki.app/
  " cd VimWiki.app/Contents/
  " gvim Info.plist
  " - Replace CFBundleName >MacVim< with >VimWiki<
  let g:mycwd = getcwd()
  if getcwd() == expand('~/vimwiki') || getcwd() == '~/vimwiki' || !has('gui_running')
    let g:is_tabbed = 1
  else
    let g:is_tabbed = 0
  endif
  if getcwd() == expand('~/vimwiki') || getcwd() == '~/vimwiki'
    let g:is_wiki = 1
  else
    let g:is_wiki = 0
  endif
  if has("win32")
    let g:is_pc = 1
  else
    let g:is_pc = 0
  endif
" }

" Replaced with vim-husk
" " Command mode options {
"     cmap <M-f> <C-Right>
"     cmap <M-b> <C-Left>
"     cmap <C-a> <Home>
" " }

" vim-husk {
  cnoremap <expr> ∫ husk#left()
  cnoremap <expr> ƒ husk#right()
" }

" Path options {
    set path-=/usr/include
    autocmd BufRead *
        \ let s:tempPath=escape(escape(expand("%:p:h"), ' '), '\ ') |
        \ exec "set path+=" . s:tempPath
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

" GUI options {
    set guioptions-=T
    set guioptions-=r
    set guioptions-=m
    set guioptions-=L
    set guioptions-=l
    set winaltkeys=no

    " Works on Windows but not mac/linux
    " set guifont=Consolas:h14
    set guifont=Source\ Code\ Pro:h15
    " Works on mac/linux but not Windows
    " set guifont=Consolas\ 14
" }

" Filetypes {
  augroup filetypedetect
    au BufRead,BufNewFile *.thrift         setfiletype thrift
    au BufRead,BufNewFile *.tw             setfiletype python
    au BufRead,BufNewFile *.cinc           setfiletype python
    au BufRead,BufNewFile *.cconf          setfiletype python
    au BufRead,BufNewFile *.nunjucks       setfiletype jinja
  augroup END

  " Some files set type to conf for some reason (when starting with # Copyright
  " lines)
  au BufEnter *.cinc    setfiletype python
  au BufEnter *.cconf   setfiletype python
  au BufEnter *.tw      setfiletype python
" }

" Shortcuts {
    command! Cwd lcd %:p:h

    " Search for selected text.
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

    " clang-format
    map <C-K> :pyf /mnt/vol/engshare/admin/scripts/vim/clang-format.py<CR>
    imap <C-K> <ESC>:pyf /mnt/vol/engshare/admin/scripts/vim/clang-format.py<CR>i
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

    " Helps issue where long multiline strings or comments cause syntax to get
    " out of sync
    au FileType python syn sync minlines=2000

    " Go to last line in given file
    autocmd BufReadPost *
        \ if line("'\"") > 1 && line("'\"") <= line("$") |
        \ exe "normal! g`\"" |
        \ endif
" }

" Ruby (plugin comes with vim) {
    let g:ruby_path = 'd:\Programs\Development\Ruby192\bin'
    let g:rubycomplete_buffer_loading = 1
    let g:rubycomplete_rails = 1
    let g:rubycomplete_classes_in_global = 1
" }

" " Neocomplcache options {
"     " if !exists('g:neocomplcache_omni_patterns')
"     let g:neocomplcache_omni_patterns = {}
"     " endif
"     " let g:neocomplcache_omni_patterns.ruby = '[^. *\t]\.\w*\|\h\w*::'
"     " let g:neocomplcache_omni_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
" 
"     let g:neocomplcache_enable_at_startup = 1
"     let g:neocomplcache_enable_auto_select = 1
"     let g:neocomplcache_enable_smart_case = 1
"     let g:neocomplcache_enable_ignore_case = 0
"     " Consider enabling this outside css/clojure files (or changing from - to
"     " another prefix char)
"     let g:neocomplcache_enable_quick_match = 0
"     "let g:neocomplcache_auto_completion_start_length = 50
"     let g:neocomplcache_snippets_disable_runtime_snippets = 1
" 
"     inoremap <expr><CR> neocomplcache#cancel_popup() . "\<CR>"
" 
"     inoremap <expr> <Tab> pumvisible() ? "\<C-y>" : "\<Tab>"
" 
"     " For use with PairTools
"     function! CallCancelPopup()
"         let result = neocomplcache#cancel_popup()
"         return result != '' ? 1 : 0
"     endfunction
"     au! BufEnter * call jigsaw#AddCarriageReturnHook('CallCancelPopup', "\<C-e>\<CR>")
" " }

" R {
  let g:vimrplugin_conqueplugin = 1
  let g:vimrplugin_underscore = 0
" }

" PairTools (most settings inside ftplugin) {
" }

" AutoPairs {
  let g:AutoPairsCenterLine = 0
  imap <C-l> <End>;
" }

" delimitMate {
  
" }

" Build options {
  "set shellpipe=

  " TODO: Set errorformat, makeprg?
" }

" Keybindings {
    "   Build keybinds
    let g:quickFixOpen = 0
    function! ToggleQuickFix()
        if g:quickFixOpen
            let g:quickFixOpen = 0
            ccl
        else
            let g:quickFixOpen = 1
            belowright copen
        endif
    endfunction
    nnoremap <F2> :cN<CR>
    nnoremap <F3> :cn<CR>
    nnoremap <F4> :silent exe "call ToggleQuickFix()"<CR>

    " General keybinds
    if g:is_tabbed == 1
      nnoremap <C-P> :tabp<CR>
      nnoremap <C-N> :tabn<CR>
      nnoremap <Leader>p :bp<CR>
      nnoremap <Leader>n :bn<CR>
      " nnoremap <M-P> :bp<CR>
      " nnoremap <M-N> :bn<CR>
      " nnoremap ð :bp<CR>
      " nnoremap î :bn<CR>
    else
      nnoremap <C-P> :MBEbp<CR>
      nnoremap <C-N> :MBEbn<CR>
      nnoremap <Leader>p :tabp<CR>
      nnoremap <Leader>n :tabn<CR>
      " nnoremap <M-p> :tabp<CR>
      " nnoremap <M-n> :tabn<CR>
      " nnoremap ð :tabp<CR>
      " nnoremap î :tabn<CR>
    endif
    "nmap <C-S> ;A<CR>

    " Swap ; and : in normal mode
    nnoremap : ;
    nnoremap ; :
    vnoremap : ;
    vnoremap ; :

    nnoremap <M-g> <C-U>
    nnoremap <M-b> <C-D>

    " Swap ' and ` (default ` jumps to mark line and column, while ' just jumps to line, this makes the more useful binding
    " ')
    nnoremap ' `
    nnoremap ` '

    nnoremap <Up> <C-W>k
    nnoremap <Down> <C-W>j
    nnoremap <Left> <C-W>h
    nnoremap <Right> <C-W>l
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

  " Jedi (j)
  " Note: Bindings in jedi-vim section
" }

" FSwitch {
    " au! BufEnter *.cpp let b:fswitchdst = 'h' | let b:fswitchlocs = '.,../inc'
    " au! BufEnter *.h let b:fswitchdst = 'cpp' | let b:fswitchlocs = '.,../lib'
    au! BufEnter *.cpp let b:fswitchdst = 'h'
    au! BufEnter *.h let b:fswitchdst = 'cpp'

    nnoremap <silent> <C-S> :FSHere<CR>
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

" CamelCaseMotion {
  " nmap <C-L> <Plug>CamelCaseMotion_w
  " nmap <C-H> <Plug>CamelCaseMotion_b
  omap <silent> .w <Plug>CamelCaseMotion_iw
  xmap <silent> .w <Plug>CamelCaseMotion_iw
" }

nmap <leader>pt ;ptj <C-R><C-W><CR>
" nmap <leader>t ;tjump <C-R><C-W><CR>
nmap <leader>c ;pc<CR>
" nmap <leader>k ;cf buildchk.err<CR>
" nmap <leader>d ;cd %:p:h<CR>
nmap <leader>s ;vim // **<Left><Left><Left><Left>
nnoremap <leader>o :vim // `git diff --name-only`<Home><Right><Right><Right><Right><Right>

" TODO: Saving and loading cursor position:
"nmap <leader>test ;let cursorPos = getpos('.')<CR>;call whatevercommand()<CR>;call setpos('.', cursorPos)<CR>
nmap <leader>= ;call BreakupLine()<CR>
nmap ,n ;tn<CR>
nmap ,p ;tp<CR>

" imap <C-L> <C-_>
" TODO: Consider replacing with ]} and [{
inoremap <M-k> <C-O>:call search('{', 'b')<CR><Right>
nnoremap <M-k> :call search('{', 'b')<CR>
inoremap <M-j> <C-O>:call search('}')<CR><Right>
nnoremap <M-j> :call search('}')<CR>

nnoremap <silent> <leader>h :silent :nohlsearch<CR>

" Fuzzyfinder {
  " nnoremap <leader>f :FufCoverageFile<CR>
  " nnoremap <leader>g :FufMruFile<CR>
  "nnoremap <leader>d :FufFile<CR>
" }

" CtrlP {
  let g:ctrlp_map = '<leader>f'
  " let g:ctrlp_split_window = 1

  " Would like this on, but this results in matching .swp and .swo files -
  " https://github.com/kien/ctrlp.vim/issues/19
  let g:ctrlp_dotfiles = 0
  " TODO: Set g:ctrlp_custom_ignore instead

  if g:is_tabbed == 0 || g:is_wiki == 1
    let g:ctrlp_prompt_mappings = {
      \ 'AcceptSelection("t")': ['<c-t>'],
      \ 'AcceptSelection("e")': ['<cr>', '<2-LeftMouse>'],
      \ }
  else
    let g:ctrlp_prompt_mappings = {
      \ 'AcceptSelection("e")': ['<c-t>'],
      \ 'AcceptSelection("t")': ['<cr>', '<2-LeftMouse>'],
      \ }
  endif

  let g:ctrlp_working_path_mode = 1

  nnoremap <leader>b :CtrlPBuffer<CR>
  nnoremap <leader>g :CtrlPMRUFiles<CR>
  nnoremap <leader>v :CtrlP getcwd()<CR>
" }

" Omni completion
" let OmniCpp_NamespaceSearch = 2
" let OmniCpp_ShowPrototypeInAbbr = 1
" let OmniCpp_DefaultNamespaces = ["std", "boost", "std::tr1"]
" let OmniCpp_MayCompleteScope = 1
" Preview also shows help for the relevant function - but dissappears at an
" inconvenient time
" set completeopt=menu,preview
set completeopt=menu
"set completeopt=menuone,menu,longest,preview

" Header source switching
let g:alternateSearchPath = 'sfr:../source,sfr:../src,sfr:../include,sfr:../inc,sfr:../lib'

" Clojure config
let g:vimclojure#ParenRainbow = 1
let g:vimclojure#DynamicHighlighting = 1

let vimclojure#WantNailgun = 1
let vimclojure#NailgunClient = 'd:\Programs\Development\vimclojure-2.2.0\ng.exe'

" Rails config {
    " Lets rails start a browser
    " command -bar -nargs=1 OpenURL :!start cmd /cstart /b <args>
    " nnoremap <leader>r :R<CR>
    " nnoremap <leader>s :A<CR>
    " nnoremap <leader>d :tabe %<CR>:Rfind 
" }

" " Fuzzyfinder {
"     let g:fuf_file_exclude = '\v(^|[/\\])(rake|tmp|\.idea)($|[/\\])|\~$|\.(o|exe|dll|bak|orig|swp)$|(^|[/\\])\.(hg|git|bzr)($|[/\\])'
"     let g:fuf_coveragefile_exclude = '\v(^|[/\\])(rake|tmp|\.idea)($|[/\\])|\~$|\.(o|exe|dll|bak|orig|swp)$|(^|[/\\])\.(hg|git|bzr)($|[/\\])'
" " }

" EasyMotion {
    let g:EasyMotion_leader_key = ','
" }

" Arpeggio {
    call arpeggio#load()
    let g:arpeggio_timeoutlen = 60
    Arpeggio inoremap jk <Esc>
    Arpeggio cnoremap jk <C-c>
    Arpeggio vnoremap jk <Esc>
    Arpeggio onoremap jk <Esc>
    Arpeggio nmap we <Plug>(easymotion-s2)
    Arpeggio vmap we <Plug>(easymotion-s2)
    Arpeggio imap cv <M-e>
" }

" Rainbow {
    nnoremap <leader>( :RainbowParenthesesToggle<CR>
" }

" Fugitive {
    " Required for the diff cmd (otherwise it tries to create a swap file that doesn't exist)
    set directory+=,~/tmp,$TMP
" }

" Status line and ruler formats {
    set title
    set laststatus=2

    " Broken down into easily includeable segments
    set statusline=%<%f\   " Filename
    set statusline+=%w%h%m%r " Options
    "set statusline+=%{fugitive#statusline()} "  Git Hotness
    set statusline+=\ [%{&ff}/%{strlen(&fenc)?&fenc:'noenc'}/%{strlen(&ft)?&ft:'notype'}]            " filetype
    set statusline+=\ [%{getcwd()}]          " current dir
    set statusline+=\ %#Error#%{SyntasticStatuslineFlag()}%*
    "set statusline+=\ [A=\%03.3b/H=\%02.2B] " ASCII / Hexadecimal value of char
    set statusline+=%=%-14.(%l/%L,%c%V%)\ %p%%  " Right aligned file nav info

    set rulerformat=%30(%=\:b%n\ %y%m%r%w\ %l/%L,%c%V\ %P%)
" }

" ShowMarks {
    let g:showmarks_include = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
" }

" Syntastic {
    " Currently disabled
    let g:syntastic_disabled_filetypes = ['cpp', 'java']
    let g:syntastic_mode_map = {
        \ 'mode': 'active',
        \ 'active_filetypes': ['ruby', 'php', 'python'],
        \ 'passive_filetypes': ['cpp', 'java']
    \ }
    let g:syntastic_python_flake8_args = "--config " . expand("~/VimConfig/.flake8-vim")
    let g:syntastic_python_checkers = ["flake8"]

    let g:tagbar_type_php = {
        \ 'ctagstype' : 'php',
        \ 'kinds'     : [
            \ 'g:enums',
            \ 'e:enumerators',
            \ 't:typedefs',
            \ 'n:namespaces',
            \ 'c:classes',
            \ 's:structs',
            \ 'f:functions',
            \ 'm:members',
            \ 'v:variables'
        \ ],
        \ 'sro'        : '::',
        \ 'kind2scope' : {
            \ 'g' : 'enum',
            \ 'n' : 'namespace',
            \ 'c' : 'class',
            \ 's' : 'struct',
        \ },
        \ 'scope2kind' : {
            \ 'enum'      : 'g',
            \ 'namespace' : 'n',
            \ 'class'     : 'c',
            \ 'struct'    : 's',
        \ }
    \ }
" }

" xptemplate {
    " Rebound here to support terminal vim (which doesn't like unicode + alt
    " key mappings)
    " Arpeggioimap -9l <C-\>
    let g:xptemplate_key = '<M-t>'
    let g:xptemplate_nav_prev = '<M-3>'
    let g:xptemplate_nav_next = '<M-4>'
" }

" " UltiSnips {
"   let g:UltiSnipsExpandTrigger='<M-t>'
"   let g:UltiSnipsJumpForwardTrigger='<M-4>'
"   let g:UltiSnipsJumpBackwardTrigger='<M-3>'
" " }

" TagBar {
    let g:tagbar_ctags_bin = '~/tagbar-ctags.sh'

    let g:tagbar_expand = 1

    " Let tagbar open/closed persist across tabs
    let g:showWindows = 0
    function! ProcessWindowsInTab()
       TagbarToggle
    endfunction
    function! UpdateWindowsInTab()
       if !exists("t:showWindows")
           let t:showWindows = 0
       endif
       if g:showWindows != t:showWindows
           if g:showWindows
               call ProcessWindowsInTab()
           else
               call ProcessWindowsInTab()
           endif
           let t:showWindows = g:showWindows
       endif
    endfunction
    function! ToggleWindowsInTab()
       if g:showWindows
           let g:showWindows = 0
           call UpdateWindowsInTab()
       else
           let g:showWindows = 1
           call UpdateWindowsInTab()
       endif
    endfunction
    function! EnableWindowsInTab()
       let g:showWindows = 1
       call UpdateWindowsInTab()
    endfunction
    nnoremap <silent> <F8> :silent exe "call ToggleWindowsInTab()"<CR>
" }

" Php {
    let g:tagbar_type_php = {
        \ 'ctagstype' : 'php',
        \ 'kinds'     : [
            \ 'g:enums',
            \ 'e:enumerators',
            \ 't:typedefs',
            \ 'n:namespaces',
            \ 'c:classes',
            \ 's:structs',
            \ 'f:functions',
            \ 'm:members',
            \ 'v:variables'
        \ ],
        \ 'sro'        : '::',
        \ 'kind2scope' : {
            \ 'g' : 'enum',
            \ 'n' : 'namespace',
            \ 'c' : 'class',
            \ 's' : 'struct',
        \ },
        \ 'scope2kind' : {
            \ 'enum'      : 'g',
            \ 'namespace' : 'n',
            \ 'class'     : 'c',
            \ 'struct'    : 's',
        \ }
    \ }

    " TODO: indentexpr for php is broken, for now use cindent
    " (future: update to work well with xhp)
    au FileType php set indentexpr= sw=2 sts=2 et cindent
    au FileType php set formatoptions-=w
    au FileType php set omnifunc=

    " Huge hack: for some reason default php scripts always add w to
    " formatoptions, and they do it after any of the other autocmds
    au InsertEnter *.php set formatoptions-=w
" }

" Ragtag {
  let g:ragtag_global_maps = 1
  imap <C-\> <C-X>/
" }

if g:use_ycm
  " YouCompleteMe {
    " Note: To fix utf-8 errors, update third_party/ycmd/ycmd/utils.py from:
    "   return str( value, 'utf8' )
    " to:
    "   return str( value, 'utf8', errors='ignore' )
    " Manual install from
    " https://bitbucket.org/Haroogan/vim-youcompleteme-for-windows
    " In vc++ 2008 command prompt - python install.py --msvc 12
    " let g:ycm_global_ycm_extra_conf = '~/VimConfig/.ycm_extra_conf.py'
    let g:ycm_confirm_extra_conf = 0
    set encoding=utf-8

    " Very nice, but throws random errors in fbcode
    let g:ycm_register_as_syntastic_checker = 0
    let g:ycm_collect_identifiers_from_comments_and_strings = 1
    let g:ycm_autoclose_preview_window_after_completion = 0
    let g:ycm_autoclose_preview_window_after_insertion = 1
    let g:ycm_complete_in_strings = 1
    let g:ycm_complete_in_comments = 1

    " E.g. open the preview window (and other windows) below the current window
    set splitbelow

    " let g:ycm_show_diagnostics_ui = 1
    " let g:ycm_error_symbol = 'x'
    " let g:ycm_warning_symbol = '!'
    " let g:ycm_enable_diagnostic_signs = 1
    " let g:ycm_enable_diagnostic_highlighting = 1
    " let g:ycm_echo_current_diagnostic = 1

    " Default blacklist includes text also
    let g:ycm_filetype_whitelist = { '*': 1 }
    "  \ 'vimwiki' : 1,
    let g:ycm_filetype_blacklist = {
      \ 'tagbar' : 1,
      \ 'qf' : 1,
      \ 'notes' : 1,
      \ 'markdown' : 1,
      \ 'unite' : 1,
      \ 'pandoc' : 1,
      \ 'infolog' : 1,
      \ 'mail' : 1
    \ }
  " }
endif

" Obsession (session manager) {
  " TODO: If using this, use expand(~/vim-sessions)
  " nnoremap <leader>z :Obsess /home/jbrewer/vim-sessions/.vim<Left><Left><Left><Left>
  " nnoremap <leader>z :source /home/jbrewer/vim-sessions/
" }

" Vimwiki {
  let g:vimwiki_hl_headers = 1
  let g:vimwiki_conceallevel = 0
  " inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"

  " Note: Could put in ftplugin, but nice to have here. Resolve conflict between
  " vimwiki and YCM
  autocmd FileType vimwiki inoremap <expr> <buffer> <Tab> pumvisible() ? "\<C-n>" : vimwiki#tbl#kbd_tab()
" }

" MiniBufExpl {
  if g:is_tabbed == 1
    nnoremap <Leader>d :bd<CR>

    let g:miniBufExplorerAutoStart = 0
  else
    nnoremap <Leader>d :MBEbd<CR>

    let g:miniBufExplVSplit = 30   " Column width in chars
    let g:miniBufExplBRSplit = 0   " Split on left

    let g:miniBufExplorerAutoStart = 1
    let g:miniBufExplBuffersNeeded = 0
    let g:miniBufExplShowBufNumbers = 0
    let g:miniBufExplCycleArround = 1
  endif
" }

" ack.vim {
  if executable('ag')
    let g:ackprg = 'ag --vimgrep'
  endif
" }

" iTerm {
  " tmux will only forward escape sequences to the terminal if surrounded by a DCS sequence
  " http://sourceforge.net/mailarchive/forum.php?thread_name=AANLkTinkbdoZ8eNR1X2UobLTeww1jFrvfJxTMfKSq-L%2B%40mail.gmail.com&forum_name=tmux-users

  if exists('$TMUX')
    let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
    let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
  else
    let &t_SI = "\<Esc>]50;CursorShape=1\x7"
    let &t_EI = "\<Esc>]50;CursorShape=0\x7"
  endif
" }

" vim-ipython {
  let g:ipy_completefunc = 'local'
  " TODO: Use let g:ipy_perform_mappings=0 and map better keys
" }

" devdocsbuf {
  " let g:devdocsbuf_devdocs_path = '~/bin/devdocs/public/docs/'
" }

" devdocs {
  " let g:devdocs_host = 'localhost:9292'
  " let g:devdocs_filetype_map = {
  "   \   'python': '*',
  "   \ }
  " nmap K <Plug>(devdocs-under-cursor)
" }

" jedi-vim {
  let g:jedi#auto_vim_configuration = 0
  let g:jedi#popup_on_dot = 0
  let g:jedi#popup_select_first = 0

  " 1 shows inline, 2 shows in command window
  "
  " 1 is too noisy to be automatic, but much more helpful (multiline). In
  " future, consider instead setting the call signatures to a hotkey
  let g:jedi#show_call_signatures = 2
  let g:jedi#show_call_signatures_delay = 0

  " Required for show_call_signatures = 2
  set noshowmode

  let g:jedi#completions_enabled = 0
  let g:jedi#smart_auto_mappings = 0

  " Bindings
  let g:jedi#goto_command = '<Space>jd'
  let g:jedi#goto_assignments_command = '<Space>jg'
  let g:jedi#usages_command = '<Space>jn'
  let g:jedi#rename_command = '<Space>jr'
  " let g:jedi#documentation_command = 'K'
" }

if !g:use_ycm
  " nvim-completion-manager {
    " NOTES:
    " - Doesn't work (windows, 2017-12-10)
    " - Doesn't pull correct sources (tries to complete python with css), omnifunc
    "   not set
    " set encoding=utf-8
    " let $NVIM_PYTHON_LOG_FILE="C:/temp_ncm_logs/"
    " let $NVIM_NCM_LOG_LEVEL="DEBUG"
    " let $NVIM_NCM_MULTI_THREAD=0
  " }

  " deoplete {
    let g:deoplete#enable_at_startup = 1
    let g:deoplete#enable_camel_case = 1
    let g:deoplete#auto_complete_delay = 0
    let g:python3_host_prog = 'python'

    set encoding=utf-8
    inoremap <silent><expr> <TAB> pumvisible() ? "\<C-n>" : "\<Tab>"
  "     inoremap <expr> <Tab> pumvisible() ? "\<C-y>" : "\<Tab>"
  " }
endif

if has('win32')
  source ~/VimConfig/_vimrc.windows
else
  source ~/VimConfig/_vimrc.mac
endif
