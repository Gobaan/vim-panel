"CLASS: KeyMap
"============================================================
let s:KeyMap = {}
let s:VimPanelKeyMap = s:KeyMap
let s:keyMaps = {}

"FUNCTION: KeyMap.All() {{{1
function! s:KeyMap.All()
    let sortedKeyMaps = values(s:keyMaps)
    call sort(sortedKeyMaps, s:KeyMap.Compare, s:KeyMap)

    return sortedKeyMaps
endfunction

"FUNCTION: KeyMap.Compare(keyMap1, keyMap2) {{{1
function! s:KeyMap.Compare(keyMap1, keyMap2)

    if a:keyMap1.key >? a:keyMap2.key
        return 1
    endif

    if a:keyMap1.key <? a:keyMap2.key
        return -1
    endif

    return 0
endfunction

"FUNCTION: KeyMap.FindFor(key) {{{1
function! s:KeyMap.FindFor(key)
    return get(s:keyMaps, a:key, {})
endfunction

"FUNCTION: KeyMap.BindAll() {{{1
function! s:KeyMap.BindAll()
    for i in values(s:keyMaps)
        call i.bind()
    endfor
endfunction

"FUNCTION: KeyMap.bind() {{{1
function! s:KeyMap.bind()
    " If the key sequence we're trying to map contains any '<>' notation, we
    " must replace each of the '<' characters with '<lt>' to ensure the string
    " is not translated into its corresponding keycode during the later part
    " of the map command below
    " :he <>
    let specialNotationRegex = '\m<\([[:alnum:]_-]\+>\)'
    if self.key =~# specialNotationRegex
        let keymapInvokeString = substitute(self.key, specialNotationRegex, '<lt>\1', 'g')
    else
        let keymapInvokeString = self.key
    endif
    let keymapInvokeString = escape(keymapInvokeString, '\')

    let premap = self.key ==# '<LeftRelease>' ? ' <LeftRelease>' : ' '

    exec 'nnoremap <buffer> <silent> '. self.key . premap . ':call nerdtree#ui_glue#invokeKeyMap("'. keymapInvokeString .'")<cr>'
endfunction

"FUNCTION: KeyMap.Remove(key) {{{1
function! s:KeyMap.Remove(key)
    return remove(s:keyMaps, a:key)
endfunction

"FUNCTION: KeyMap.invoke() {{{1
"Call the KeyMaps callback function
function! s:KeyMap.invoke(...)
    let Callback = type(self.callback) ==# type(function('tr')) ? self.callback : function(self.callback)
    if a:0
        call Callback(a:1)
    else
        call Callback()
    endif
endfunction

"FUNCTION: KeyMap.Invoke() {{{1
function! s:KeyMap.Invoke(key)

    "required because clicking the command window below another window still
    "invokes the <LeftRelease> mapping - but changes the window cursor
    "is in first
    "
    "TODO: remove this check when the vim bug is fixed
    if empty(b:VimPanel.scope)
        return {}
    endif

    let km = s:KeyMap.FindFor(a:key)
    if !empty(km)
        return km.invoke()
    endif
endfunction

"FUNCTION: KeyMap.Create(options) {{{1
function! s:VimPanelKeyMap.Create(options)
    let opts = extend({'quickhelpText': ''}, copy(a:options))

    "dont override other mappings unless the 'override' option is given
    if get(opts, 'override', 0) ==# 0 && !empty(s:KeyMap.FindFor(opts['key']))
        return
    end

    let newKeyMap = copy(self)
    let newKeyMap.key = opts['key']
    let newKeyMap.quickhelpText = opts['quickhelpText']
    let newKeyMap.callback = opts['callback']

    call s:KeyMap.Add(newKeyMap)
endfunction

"FUNCTION: KeyMap.Add(keymap) {{{1
function! s:KeyMap.Add(keymap)
    let s:keyMaps[a:keymap.key] = a:keymap
endfunction

" vim: set sw=4 sts=4 et fdm=marker:
