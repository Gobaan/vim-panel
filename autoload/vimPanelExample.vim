" usage: load this script by writing call vimPanelExample#echo()
" then press the shortcut 'a' on the new buffer to change the panel to the sentence goodbye

function! vimPanelExample#saygoodbye()
     call vimSidePanel#Render('goodbye', 'example')
endfunction

function! vimPanelExample#echo()
    call vimSidePanel#Render('hello world', 'example')
    call keyMap#Create({'scope':'example', 'text': 'press a to say goodbye', 'key': 'a', 'callback': function('example#saygoodbye')})
    call keyMap#BindAll()
endfunction

" TODO: add an example that prints the line under the cursor
