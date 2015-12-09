set rtp+=~/.vim/manual-bundle/YouCompleteMe
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

  Plugin 'vim-scripts/Auto-Pairs'
  Plugin 'kana/vim-arpeggio'

  Plugin 'kien/ctrlp.vim'
  Plugin 'sjl/gundo.vim'
  Plugin 'vim-scripts/Parameter-Text-Objects'
  Plugin 'vim-scripts/swap-parameters'
  Plugin 'scrooloose/syntastic'
  Plugin 'tomtom/tcomment_vim'
  Plugin 'tpope/vim-abolish'
  Plugin 'Lokaltog/vim-easymotion'
  Plugin 'hynek/vim-python-pep8-indent'
  Plugin 'tpope/vim-ragtag'
  Plugin 'tpope/vim-repeat'
  Plugin 'tpope/vim-surround'
  Plugin 'tpope/vim-unimpaired'

  " Colors
  Plugin 'altercation/vim-colors-solarized'
  Plugin 'd11wtq/tomorrow-theme-vim'
  Plugin 'tomasr/molokai'
  " Plugin 'jpo/vim-railscasts-theme'

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

" Colors {
  let g:molokai_original = 1
  colorscheme molokai
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

  set lcs=tab:»\ ,trail:·,extends:#,nbsp:.
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
" }

" Command mode options {
    cmap <M-f> <C-Right>
    cmap <M-b> <C-Left>
    cmap <C-a> <Home>
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

    set hidden

    " Tab options
    set showtabline=2
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

    nmap <silent> <Plug>VLToggle :let g:VeryLiteral = !g:VeryLiteral
      \\| echo "VeryLiteral " . (g:VeryLiteral ? "On" : "Off")<CR>
    if !hasmapto("<Plug>VLToggle")
      nmap <unique> <Leader>vl <Plug>VLToggle
    endif
    let &cpo = s:save_cpo | unlet s:save_cpo

    " clang-format
    map <C-K> :pyf /mnt/vol/engshare/admin/scripts/vim/clang-format.py<CR>
    imap <C-K> <ESC>:pyf /mnt/vol/engshare/admin/scripts/vim/clang-format.py<CR>i
" }

" Auto commands {
    "au GUIEnter * simalt ~x

    " au TabEnter * source ~/VimConfig/TabEnter.vim
    au FileType ruby,eruby,yaml set ai sw=2 sts=2 et
    au FileType cpp set ai sw=2 sts=2 et

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
    map <F2> ;cN<CR>
    map <F3> ;cn<CR>
    map <F4> ;silent exe "call ToggleQuickFix()"<CR>

    " General keybinds
    nmap <C-P> ;tabp<CR>
    nmap <C-N> ;tabn<CR>
    nmap <M-p> ;bp<CR>
    nmap <M-n> ;bn<CR>
    "nmap <C-S> ;A<CR>

    " Swap ; and : in normal mode
    nnoremap : ;
    nnoremap ; :
    vnoremap : ;
    vnoremap ; :

    noremap <M-g> <C-U>
    noremap <M-b> <C-D>

    " Swap ' and ` (default ` jumps to mark line and column, while ' just jumps to line, this makes the more useful binding
    " ')
    nnoremap ' `
    nnoremap ` '
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

" Jumping
nmap <C-L> <Plug>CamelCaseMotion_w
nmap <C-H> <Plug>CamelCaseMotion_b

" let g:camelchar = "A-Z0-9.,;:{([`'\""
" let g:searchpattern = '\C\<\|\%(^\|[^'.g:camelchar.']\@<=\)['.g:camelchar.']\|['.g:camelchar.']\ze\%([^'.g:camelchar.']\&\>\@!\)\|\%$'
" function! GetNextCharacter(params)
"     let l:result = search(g:searchpattern, a:params)
" endfunction
" 
" function! SelectCasedWord()
"     let l:initial = getpos('.')
" 
"     call GetNextCharacter('bW')
"     let l:startPos = getpos('.')
" 
"     call setpos('.', l:initial)
"     call GetNextCharacter('W')
"     let l:endPos = getpos('.')
"     let l:endPos[2] = l:endPos[2] - 1
" 
"     call setpos('.', l:startPos)
"     normal! v
"     call setpos('.', l:endPos)
" endfunction
" 
" nnoremap <silent><C-H> :<C-u>call GetNextCharacter('bW')<CR>
" nnoremap <silent><C-L> :<C-u>call GetNextCharacter('W')<CR>
" onoremap <silent><C-H> :<C-u>call GetNextCharacter('bW')<CR>
" onoremap <silent><C-L> :<C-u>call GetNextCharacter('W')<CR>
" onoremap <silent>ah :<C-u>call SelectCasedWord()<CR>
" onoremap <silent>ih :<C-u>call SelectCasedWord()<CR>
" vnoremap <silent><C-H> :<C-u>call GetNextCharacter('bW')<CR>
" vnoremap <silent><C-L> :<C-u>call GetNextCharacter('W')<CR>
" vnoremap <silent>ah :<C-u>call SelectCasedWord()<CR><Esc>gv
" vnoremap <silent>ih :<C-u>call SelectCasedWord()<CR><Esc>gv

"nnoremap <silent><C-H>  :cal search('\C\<\<Bar>\%(^\<Bar>[^'.g:camelchar.']\@<=\)['.g:camelchar.']\<Bar>['.g:camelchar.']\ze\%([^'.g:camelchar.']\&\>\@!\)\<Bar>\%^','bW')<CR>
"nnoremap <silent><C-L> :cal search('\C\<\<Bar>\%(^\<Bar>[^'.g:camelchar.']\@<=\)['.g:camelchar.']\<Bar>['.g:camelchar.']\ze\%([^'.g:camelchar.']\&\>\@!\)\<Bar>\%$','W')<CR>
"vnoremap <silent><C-H>  :cal search('\C\<\<Bar>\%(^\<Bar>[^'.g:camelchar.']\@<=\)['.g:camelchar.']\<Bar>['.g:camelchar.']\ze\%([^'.g:camelchar.']\&\>\@!\)\<Bar>\%^','bW')<CR>
"vnoremap <silent><C-L> :cal search('\C\<\<Bar>\%(^\<Bar>[^'.g:camelchar.']\@<=\)['.g:camelchar.']\<Bar>['.g:camelchar.']\ze\%([^'.g:camelchar.']\&\>\@!\)\<Bar>\%$','W')<CR>
"onoremap <silent><C-H>  :cal search('\C\<\<Bar>\%(^\<Bar>[^'.g:camelchar.']\@<=\)['.g:camelchar.']\<Bar>['.g:camelchar.']\ze\%([^'.g:camelchar.']\&\>\@!\)\<Bar>\%^','bW')<CR>
"onoremap <silent><C-L> :cal search('\C\<\<Bar>\%(^\<Bar>[^'.g:camelchar.']\@<=\)['.g:camelchar.']\<Bar>['.g:camelchar.']\ze\%([^'.g:camelchar.']\&\>\@!\)\<Bar>\%$','W')<CR>

" Text insertion templates
" TODO: Add these

" function! OpenQuickfixFiles()
"     let qflist = getqflist()
"     for f in qflist
"         let buf = f['bufnr']
"         exe ":b " . buf
"         setlocal buflisted
"     endfor
" endfunction
" nmap <leader>q ;call OpenQuickfixFiles()<CR>

" Can use 'iab foo Bar' to do abbreviations

"iab ,f C<C-R>=fnamemodify(expand('%'), ":t:r")<CR>

" Protodef
"let g:disable_protodef_mapping = 1
"let g:protodefprotogetter = "perl " . $HOME . "/vimfiles/pullproto.pl"
"nnoremap <silent> <leader>dp :set paste<cr>i<c-r>=protodef#ReturnSkeletonsFromPrototypesForCurrentBuffer({})<cr><esc>='[:set nopaste<cr>
"nnoremap <silent> <leader>dn :set paste<cr>i<c-r>=protodef#ReturnSkeletonsFromPrototypesForCurrentBuffer({'includeNS' : 0})<cr><esc>='[:set nopaste<cr>
"nnoremap <buffer> <silent> <leader>dp :set paste<cr>i<c-r>=protodef#ReturnSkeletonsFromPrototypesForCurrentBuffer({})<cr><esc>='[:set nopaste<cr>
"nnoremap <buffer> <silent> <leader>dn :set paste<cr>i<c-r>=protodef#ReturnSkeletonsFromPrototypesForCurrentBuffer({'includeNS' : 0})<cr><esc>='[:set nopaste<cr>

" Tags

"" Old (TList)
"let g:showWindows = 0
"function! ProcessWindowsInTab()
"    TlistToggle
"endfunction
"function! UpdateWindowsInTab()
"    if !exists("t:showWindows")
"        let t:showWindows = 0
"    endif
"    if g:showWindows != t:showWindows
"        if g:showWindows
"            call ProcessWindowsInTab()
"        else
"            call ProcessWindowsInTab()
"        endif
"        let t:showWindows = g:showWindows
"    endif
"endfunction
"function! ToggleWindowsInTab()
"    if g:showWindows
"        let g:showWindows = 0
"        call UpdateWindowsInTab()
"    else
"        let g:showWindows = 1
"        call UpdateWindowsInTab()
"    endif
"endfunction
"nnoremap <silent> <F8> :silent exe "call ToggleWindowsInTab()"<CR>

"let Tlist_Ctags_Cmd='d:\Programs\Development\ctags\ctags.exe'
"let Tlist_Exit_OnlyWindow=1
"let Tlist_Use_Right_Window=1
"let Tlist_WinWidth=35
"let Tlist_Compact_Format=1
"
"let Tlist_Enable_Fold_Column=0
"let Tlist_File_Fold_Auto_Close=1
"let Tlist_Sort_Type="order"
"nnoremap <silent> <F8> :TlistToggle<CR>
" map <silent> <F7> :TlistShowTag<CR>
" map <silent> <F6> :TlistShowPrototype<CR>
" TODO: set tags

" so ~/VimConfig/UtilityMethods.vim
"nmap <leader>r ;so ~/UtilityMethods.vim<CR>

nmap <leader>pt ;ptj <C-R><C-W><CR>
" nmap <leader>t ;tjump <C-R><C-W><CR>
nmap <leader>c ;pc<CR>
nmap <leader>k ;cf buildchk.err<CR>
nmap <leader>d ;cd %:p:h<CR>
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
  let g:ctrlp_split_window = 1

  " Would like this on, but this results in matching .swp and .swo files -
  " https://github.com/kien/ctrlp.vim/issues/19
  let g:ctrlp_dotfiles = 0
  " TODO: Set g:ctrlp_custom_ignore instead

  let g:ctrlp_working_path_mode = 1

  nnoremap <leader>b :CtrlPBuffer<CR>
  nnoremap <leader>g :CtrlPMRUFiles<CR>
" }

" Omni completion
" let OmniCpp_NamespaceSearch = 2
" let OmniCpp_ShowPrototypeInAbbr = 1
" let OmniCpp_DefaultNamespaces = ["std", "boost", "std::tr1"]
" let OmniCpp_MayCompleteScope = 1
set completeopt=menu,preview
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

function! SendToConque(type)
    " get most recent/relevant terminal
    let term = conque_term#get_instance()

    " shove visual text into @@ register
    let reg_save = @@
    sil exe "normal! `<" . a:type . "`>y"
    let @@ = substitute(@@, '^[\r\n]*', '', '')
    let @@ = substitute(@@, '[\r\n]*$', '', '')

    " go to terminal buffer
    call term.focus()

    " execute yanked text
    call term.writeln(@@)

    " reset original values
    let @@ = reg_save

    " scroll buffer left
    startinsert!
    normal! 0zH
endfunction

" Conque {
    " TODO: Add PyExe path if this is used often
    " vnoremap p :<C-U>call SendToConque(visualmode())<CR>
    " let g:ConqueTerm_CWInsert = 1

    imap <F1> <Esc><C-W><C-W>
    nmap <F1> <C-W><C-W>
" }

" Space {
    let g:space_no_character_movements = 1
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
    " Currently too slow to enable on fbcode
    let g:syntastic_disabled_filetypes = ['cpp', 'java']
    let g:syntastic_mode_map = {
        \ 'mode': 'active',
        \ 'active_filetypes': ['ruby', 'php', 'python'],
        \ 'passive_filetypes': ['cpp', 'java']
    \ }

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

" YouCompleteMe {
  " Manual install from
  " https://bitbucket.org/Haroogan/vim-youcompleteme-for-windows
  " let g:ycm_global_ycm_extra_conf = '~/VimConfig/.ycm_extra_conf.py'
  let g:ycm_confirm_extra_conf = 0

  " Very nice, but throws random errors in fbcode
  let g:ycm_register_as_syntastic_checker = 0
  let g:ycm_collect_identifiers_from_comments_and_strings = 1
  let g:ycm_autoclose_preview_window_after_completion = 1

  " let g:ycm_show_diagnostics_ui = 1
  " let g:ycm_error_symbol = 'x'
  " let g:ycm_warning_symbol = '!'
  " let g:ycm_enable_diagnostic_signs = 1
  " let g:ycm_enable_diagnostic_highlighting = 1
  " let g:ycm_echo_current_diagnostic = 1

  " Default blacklist includes text also
  let g:ycm_filetype_whitelist = { '*': 1 }
  let g:ycm_filetype_blacklist = {
    \ 'tagbar' : 1,
    \ 'qf' : 1,
    \ 'notes' : 1,
    \ 'markdown' : 1,
    \ 'unite' : 1,
    \ 'vimwiki' : 1,
    \ 'pandoc' : 1,
    \ 'infolog' : 1,
    \ 'mail' : 1
  \ }
" }

" Obsession (session manager) {
  " nnoremap <leader>z :Obsess /home/jbrewer/vim-sessions/.vim<Left><Left><Left><Left>
  " nnoremap <leader>z :source /home/jbrewer/vim-sessions/
" }
