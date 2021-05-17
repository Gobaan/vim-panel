# vim-panel
Library to be used to add a info panel to vim.

Install using vundle by adding the following line to your plugins.vim

```vim
Plugin 'gobaan/vim-panel'
```

Render text with the following command
```vim
call vimPanel#Render("<your_message>", "<your_plugin_name>")'
```

Toggle the panel with the following command
```vim
call vimPanel#TogglePanel()
```

Register hotkeys with the following commandA
```vim
call keyMap#Create(
\       {'scope':'<your_plugin_name>',
\        'text': '<helper message, e.g. "press o to open">',
\        'key': '<hotkey e.g. "o">',
\        'callback': <callback function> e.g. function  ('CoveragePyShow#GotoTest')})
```

See gobaan/vim-coveragepy for example usage
