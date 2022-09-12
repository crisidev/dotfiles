" Mouse handling
function! s:MouseToggleFunc()
    if !exists('s:old_mouse')
        let s:old_mouse = 'a'
    endif

    if &mouse ==? ''
        let &mouse = s:old_mouse
        echo 'Mouse is for Vim (' . &mouse . ')'
    else
        let s:old_mouse = &mouse
        let &mouse=''
        echo 'Mouse is for terminal'
    endif
endfunction
command! MouseToggle :call <SID>MouseToggleFunc()

" Toggle numbers
function! s:NuModeToggleFunc()
    if &number == 1
        set relativenumber!
    else
        set number!
    endif
endfunction
command! NuModeToggle :call <SID>NuModeToggleFunc()

" No numbers
function! s:NoNuModeFunc()
    set norelativenumber
    set nonumber
endfunction            
command! NoNuMode :call <SID>NoNuModeFunc()

" Clean search with <esc>
nnoremap <silent><esc> :noh<CR>
nnoremap <esc>[ <esc>[

" Disable syntax highlighting in big files
function! DisableSyntaxTreesitter()
    echo('Big file, disabling syntax, treesitter and folding')
    if exists(':TSBufDisable')
        exec 'TSBufDisable autotag'
        exec 'TSBufDisable highlight'
    endif
    set foldmethod=manual
    syntax clear
    syntax off
    filetype off
    set noundofile
    set noswapfile
    set noloadplugins
    set lazyredraw
endfunction

augroup BigFileDisable
    autocmd!
    autocmd BufReadPre,FileReadPre * if getfsize(expand("%")) > 1024 * 1024 | exec DisableSyntaxTreesitter() | endif
augroup END

" Grammarous configurations
let g:grammarous#default_comments_only_filetypes = {
    \ '*' : 1, 
    \ 'help' : 0, 
    \ 'markdown' : 0, 
    \ 'text' : 0,
\ }

" let g:grammarous#disabled_rules = {
"     \ '*' : ['WHITESPACE_RULE', 'EN_QUOTES', 'ARROWS', 'SENTENCE_WHITESPACE',
"     \        'WORD_CONTAINS_UNDERSCORE', 'COMMA_PARENTHESIS_WHITESPACE',
"     \        'EN_UNPAIRED_BRACKETS', 'UPPERCASE_SENTENCE_START',
"     \        'ENGLISH_WORD_REPEAT_BEGINNING_RULE', 'DASH_RULE', 'PLUS_MINUS',
"     \        'PUNCTUATION_PARAGRAPH_END', 'MULTIPLICATION_SIGN', 'PRP_CHECKOUT',
"     \        'CAN_CHECKOUT', 'SOME_OF_THE', 'DOUBLE_PUNCTUATION', 'HELL',
"     \        'CURRENCY', 'POSSESSIVE_APOSTROPHE', 'ENGLISH_WORD_REPEAT_RULE',
"     \        'NON_STANDARD_WORD'],
" \ }

" Open cargo errors in buffers
function! g:CargoLimitOpen(editor_data)
  let l:initial_file = resolve(expand('%:p'))
  if l:initial_file != '' && !filereadable(l:initial_file)
    return
  endif
  for source_file in reverse(a:editor_data.files)
    let l:path = fnameescape(source_file.path)
    if mode() == 'n' && &l:modified == 0
      execute 'edit ' . l:path
      call cursor((source_file.line), (source_file.column))
    else
      break
    endif
  endfor
endfunction
