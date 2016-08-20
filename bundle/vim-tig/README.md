Vim Tig
=======
Love [Tig](https://github.com/jonas/tig)? Me too!  
Love Vim? OMG we're totes the same!  
So here's a simple plugin to make calling tig in vim easy peasy.  
It's teh handies!

Requirements
------------
Neovim. This plugin uses Neovim's built in terminal; therefore it will crash
and burn on classic Vim. Classic support may be added if either

1. enough people want it
2. I go back to classic Vim
3. someone else does it :)

Installation
------------
Use your most favouritest plugin manager.

Usage
-----
Simply run `:Tig`  
or bind a key to it, e.g.:
```
map <C-G> :Tig<Cr>
```

Pass tig commands:
```
:Tig show
```

Show commit log of current file:
```
:Tig!
```

Configuration
-------------
Tig executable: `let g:tig_executable = 'tig'`
Tig command to run: `let g:tig_default_command = 'status'`
Vim command to run on tig exit: `let g:tig_on_exit = 'bw!'`
Vim command before opening terminal: `let g:tig_open_command = 'new'`

Contributing
------------
1. Fork it!
2. Create your feature branch: `git checkout -b my-new-feature`
3. Commit your changes: `git commit -am 'Add some feature'`
4. Push to the branch: `git push origin my-new-feature`
5. Submit a pull request :D

Credits
-------
[Nick Butler](https://www.codeindulgence.com) <nick@codeindulgence.com>
