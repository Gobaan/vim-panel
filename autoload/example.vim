let s:Example = {}

"FUNCTION: {{{1
" Binds to a key and echos the line under the buffer

function! example#echo()
   echo ("wow")
   call vimSidePanel#Render('hello', 'example')
endfunction

call keyMap#Create({'scope':'example', 'text': '(a)dd a childnode', 'key': 'a', 'callback': function('example#echo')})
"Kinda binds but need to verify
call keyMap#BindAll()
