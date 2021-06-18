# starship setup
starship init fish | source

# fzf setup
fzf_key_bindings

# zoxide setup
zoxide init fish | source
function fzf-z -d "fuzzy search recent dirs"
    _ZO_FZF_OPTS='--height 40% --layout=reverse' zi
end
bind \cg fzf-z

set fish_greeting # suppress default greeting
set EDITOR nvim
alias sizes="du -csh * | sort -h"
alias whoslistening="lsof -iTCP -sTCP:LISTEN -n -P"
alias v="$EDITOR"
alias g="git"
alias vw="$EDITOR -c VimwikiIndex"
alias vwt="$EDITOR -c VimwikiMakeDiaryNote"
alias shopping_list="$EDITOR $HOME/Documents/shopping-lists/(date --iso-8601).md"

function command-exists
    command -v $argv >/dev/null 2>&1
end

if command-exists xclip
    alias pbc='xclip -i -sel clipboard'
    alias pbp='xclip -o -sel clipboard'
else if command-exists wl-copy
    alias pbc='wl-copy'
    alias pbp='wl-paste'
else if command-exists pbcopy
    alias pbc='pbcopy'
    alias pbp='pbpaste'
end

if not command-exists open and command-exists xdg-open
    alias open='xdg-open'
end

if not command-exists trash and command-exists gio
    alias trash='gio trash'
end
