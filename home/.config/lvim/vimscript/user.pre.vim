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
