let s:Example = {}

"FUNCTION: {{{1
" Binds to a key and echos the line under the buffer

function! s:Example.echo()
   call Render('hello', 'example')
endfunction

call s:VimPanelKeyMap.Create({
    'text': '(a)dd a childnode',
    'shortcut': 'a',
    'callback': 's:Example.echo'})
