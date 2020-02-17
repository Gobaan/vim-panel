"CLASS: keyMap
"============================================================
let s:keyMap = {}
let s:VimPanelKeyMap = s:keyMap
let s:keyMaps = {}

"FUNCTION: keyMap.Create(options) {{{1
"           options : {'key': <key to register>, 'quickhelptext': <tips>,
"                      'scope':<uniq id for your buffer>, 'callback': <function to call on press>}
function! keyMap#Create(options)
    let opts = extend({'quickhelpText': ''}, copy(a:options))

    "dont override other mappings unless the 'override' option is given
    if get(opts, 'override', 0) ==# 0 && !empty(get(s:keyMap, s:keyMap.GetKey(a:options['scope'], a:options['key']), {}))
        return
    end

    call s:keyMap.Add(opts)
endfunction

"FUNCTION: KeyMap.BindAll() {{{1
function! keyMap#BindAll()
    for i in values(s:keyMaps)
        call s:keyMap.bind(i)
    endfor
endfunction

function! keyMap#invoke(scope, key)
    let options = s:keyMaps[s:keyMap.GetKey(a:scope, a:key)]
    call options['callback']()
endfunction

"FUNCTION: KeyMap.bind() {{{1
function! s:keyMap.bind(options)
    let premap = a:options['key'] ==# '<LeftRelease>' ? ' <LeftRelease>' : ' '
    exec 'nnoremap <buffer> <silent> ' . a:options['key'] . premap . ':call keyMap#invoke("' . a:options['scope'] . '", "' . a:options['key'] . '")<cr>'
endfunction

function! s:keyMap.GetKey(scope, key)
    return a:scope . ':' . a:key
endfunction

"FUNCTION: keyMap.Remove(key) {{{1
function! s:keyMap.Remove(scope, key)
    return remove(s:keyMaps, s:keyMap.GetKey(a:scope, a:key))
endfunction

"FUNCTION: keyMap.Add(keymap) {{{1
function! s:keyMap.Add(keymap)
    let s:keyMaps[s:keyMap.GetKey(a:keymap['scope'], a:keymap['key'])] = a:keymap
endfunction

" vim: set sw=4 sts=4 et fdm=marker:
