# idevtier's tmux config

### Features
A banch of custom bash scripts, that improve tmux workflow
* Interactive create and switch session with `Prefix+N`
* Fzf search and kill session with `Prefix+k`
* Open lazygit in a new window with `Prefix+g`
* Open any command in split pane `Prefix+e` (for neovim only now)

### How to install

**Important** Save your `~/.tmux.conf` first, if you have some

Firstly install [tpm](https://github.com/tmux-plugins/tpm)

Then install config:
```bash
cd ~/.config
git clone https://github.com/idevtier/tmux
rm ~/.tmux.conf
ln -s ~/.config/tmux/.tmux.conf ~/.tmux.conf
```

### Tricky moments
#### Panes navigation
My config uses [vim-tmux-navigator](https://github.com/christoomey/vim-tmux-navigator)
for navigation between neovim and tmux panes with `C+<hjkl>`.
It requires to install neovim plugin too.

