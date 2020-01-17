" TODO: choose position and size of panel
let s:VimPanel = {}
let g:VimPanel = s:VimPanel

" Exists for tab
" Function: s:VimPanel.ExistsForTab()   {{{1
" Returns 1 if a nerd tree root exists in the current tab
function! s:GetExistingPanel()
    if !exists("t:VimPanelBufferName")
        return -1
    endif
    "check b:NERDTree is still there and hasn't been e.g. :bdeleted
    let loaded = bufwinnr(t:VimPanelBufferName)
    return loaded
endfunction

" Is Panel Open
function! s:Open()
    " Open new panel
    if !exists("t:VimPanelBufferName")
        let t:VimPanelBufferName = s:NextBufferName()
    endif
    let b:VimPanel = 1
    execute 'below 10split ' . t:VimPanelBufferName
    setlocal noreadonly modifiable
    setlocal buftype=nofile
    setlocal bufhidden=hide
    setlocal noswapfile
    put! =t:VimPanelBufferName
    setlocal readonly nomodifiable
endfunction

" Toggle panel open or close
function! s:TogglePanel()
    let a:existing = (s:GetExistingPanel() !=# -1)
    if a:existing
        call s:Close()
    else
        call s:Open()
    endif
endfunction


" FUNCTION: exec(cmd, ignoreAll) {{{2
" Same as :exec cmd but, if ignoreAll is TRUE, set eventignore=all for the duration
function! s:exec(cmd, ignoreAll) abort
    let old_ei = &eventignore

    if a:ignoreAll
        set eventignore=all
    endif
    exec a:cmd
    let &eventignore = old_ei
endfunction


" Close panel
"FUNCTION: s:Close() {{{1
"Closes the tab tree window for this tab
function! s:Close()
    if !s:IsOpen()
        return
    endif

    if winnr("$") == 1
        bdelete!
        return
    endif

    " Use the window ID to identify the currently active window or fall
    " back on the buffer ID if win_getid/win_gotoid are not available, in
    " which case we'll focus an arbitrary window showing the buffer.
    let l:useWinId = exists('*win_getid') && exists('*win_gotoid')

    if winnr() == s:GetWinNum()
        call s:exec("wincmd p", 1)
        let l:activeBufOrWin = l:useWinId ? win_getid() : bufnr("")
        call s:exec("wincmd p", 1)
    else
        let l:activeBufOrWin = l:useWinId ? win_getid() : bufnr("")
    endif

    call s:exec(s:GetWinNum() . " wincmd w", 1)
    call s:exec("bdelete!", 0)

    if l:useWinId
        call s:exec("call win_gotoid(" . l:activeBufOrWin . ")", 0)
    else
        call s:exec(bufwinnr(l:activeBufOrWin) . " wincmd w", 0)
    endif
endfunction

" On key over line
"   - Trigger event, give window name, line, line number, and if its a panel or not

function! s:BufNamePrefix()
    return 'VimPanel_'
endfunction

" Get panel buffer?
"FUNCTION: s:NERDTree.GetWinNum() {{{1
"gets the nerd tree window number for this tab
function! s:GetWinNum()
    if exists('t:NERDTreeBufName')
        return bufwinnr(t:NERDTreeBufName)
    endif

    " If WindowTree, there is no t:NERDTreeBufName variable. Search all windows.
    for w in range(1,winnr('$'))
        if bufname(winbufnr(w)) =~# '^' . s:BufNamePrefix() . '\d\+$'
            return w
        endif
    endfor

    return -1
endfunction

"FUNCTION: s:NERDTree.IsOpen() {{{1
function! s:IsOpen()
    return s:GetWinNum() !=# -1
endfunction

function! s:NextBufferName()
    let name = s:BufNamePrefix() . s:NextBufferNumber()
    return name
endfunction

function! s:NextBufferNumber()
    if !exists('s:NextBufNum')
        let s:NextBufNum = 1
    else
        let s:NextBufNum += 1
    endif

    return s:NextBufNum
endfunction


command TogglePanel call s:TogglePanel()
command CheckExists call s:ExistsForTab()
