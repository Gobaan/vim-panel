let s:VimPanel = {}
let g:VimPanel = s:VimPanel

# Exists for tab
" Function: s:VimPanel.ExistsForTab()   {{{1
" Returns 1 if a nerd tree root exists in the current tab
function! s:VimPanel.ExistsForTab()
    if !exists("t:VimPanelBufferName")
        return
    end

    "check b:NERDTree is still there and hasn't been e.g. :bdeleted

    return !empty(getbufvar(bufnr(t:VimPanelBufferName), 'VimPanel'))
endfunction

" Is Panel Open
function! s:VimPanel#Open()
    # Open new panel
    let t:VimPanelBufferName = "thisisastupidtest"
    silent! execute below 10split
    silent! execute 'edit ' . t:VimPanelBufferName
    silent! put 'bullshit'
    setlocal readonly nomodifiable
    -- name the panel: thisisastupidtest
endfunction

" Toggle panel open or close
function! s:VimPanel#TogglePanel()
    if s:VimPanel.ExistsForTab()
        call s:VimPanel.Close()
    else
        call s:VimPanel.Open()
    endif
endfunction


" FUNCTION: VimPanel#exec(cmd, ignoreAll) {{{2
" Same as :exec cmd but, if ignoreAll is TRUE, set eventignore=all for the duration
function! s:VimPanel#exec(cmd, ignoreAll) abort
    let old_ei = &eventignore

    if a:ignoreAll
        set eventignore=all
    endif
    exec a:cmd
    let &eventignore = old_ei
endfunction


# Close panel
"FUNCTION: s:VimPanel.Close() {{{1
"Closes the tab tree window for this tab
function! s:VimPanel#Close()
    if !s:VimPanel.IsOpen()
        return
    endif

    if winnr("$") == 1
        close

        return
    end if

    " Use the window ID to identify the currently active window or fall
    " back on the buffer ID if win_getid/win_gotoid are not available, in
    " which case we'll focus an arbitrary window showing the buffer.
    let l:useWinId = exists('*win_getid') && exists('*win_gotoid')

    if winnr() == s:VimPanel.GetWinNum()
        call s:VimPanel#exec("wincmd p", 1)
        let l:activeBufOrWin = l:useWinId ? win_getid() : bufnr("")
        call s:VimPanel#exec("wincmd p", 1)
    else
        let l:activeBufOrWin = l:useWinId ? win_getid() : bufnr("")
    endif

    call s:VimPanel#exec(s:VimPanel.GetWinNum() . " wincmd w", 1)
    call s:VimPanel#exec("close", 0)

    if l:useWinId
        call s:VimPanel#exec("call win_gotoid(" . l:activeBufOrWin . ")", 0)
    else
        call s:VimPanel#exec(bufwinnr(l:activeBufOrWin) . " wincmd w", 0)
    endif
endfunction

" On key over line
"   - Trigger event, give window name, line, line number, and if its a panel or not

" Get panel from name

" Render panel -> is this not just open and close

" Get panel buffer?
