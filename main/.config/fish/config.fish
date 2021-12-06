# {{{ shell utils setup
set -U fish_greeting # suppress default greeting
starship init fish | source
fzf_key_bindings
fnm env --use-on-cd --log-level quiet | source

zoxide init fish | source
set -x _ZO_FZF_OPTS "--height 40% --layout=reverse"
bind \cg zi

set -x ASDF_CONFIG_FILE "$HOME/.config/asdfrc"
if [ -e /opt/asdf-vm/asdf.fish ]
    source /opt/asdf-vm/asdf.fish
end
# }}} END shell utils setup


# {{{ language env set up
fish_add_path "$HOME/.local/bin" # pip
fish_add_path "$HOME/.poetry/bin" # poetry
fish_add_path "(ruby -e 'puts Gem.user_dir')/bin" # ruby
fish_add_path "$HOME/.npm_global/bin" # npm
fish_add_path "$HOME/.yarn/bin" # yarn
fish_add_path "$HOME/.cargo/bin" # rust
fish_add_path "$HOME/.emacs.d/bin" # doom/emacs

set -x GOPATH "$HOME/go/bin"
set -x GOROOT /usr/lib/go
fish_add_path "$GOPATH" "$GOROOT"

set -x ANDROID_HOME "$HOME/Android/Sdk"
[ (uname) = "Darwin" ] && set -x ANDROID_HOME "$HOME/Library/Android/Sdk"

fish_add_path \
    "$ANDROID_HOME/emulator" \
    "$ANDROID_HOME/tools" \
    "$ANDROID_HOME/tools/bin" \
    "$ANDROID_HOME/platform-tools"
# }}} END language env set up


# {{{ misc config
set -x MANPAGER 'nvim +Man!'
set -x MANWIDTH 80
set -x RIPGREP_CONFIG_PATH "$HOME/.config/ripgreprc"
set -x FZF_DEFAULT_OPTS "--height 40% --reverse --tac"

bind \cx\ce edit_command_buffer
# }}} END misc config


# {{{ aliases and abbreviations
set -x EDITOR nvim
abbr -a -- v nvim
abbr -a -- g git
abbr -a -- y yarn

alias rg="rg --hidden"
alias sizes="du -csh * | sort -h"
alias whoslistening="ss -lntu"
alias vwt="$EDITOR -c LogbookToday"
alias shopping_list="$EDITOR $HOME/notes/shopping-lists/(date --iso-8601).md"
alias vimrc="$EDITOR -O $HOME/dotfiles/main/.config/nvim/init.lua $HOME/dotfiles/main/.config/nvim/plugins.lua"
alias fishrc="$EDITOR $HOME/dotfiles/main/.config/fish/config.fish"
alias vg="$EDITOR -c \"Git | wincmd k | q\""

abbr -a -- _ sudo
abbr -a -- \~ "cd ~"
abbr -a -- - "cd -"
abbr -a -- .. "cd .."
abbr -a -- ... "cd ../.."
abbr -a -- .... "cd ../../.."
abbr -a -- ..... "cd ../../../.."
abbr -a -- ...... "cd ../../../../.."

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
# }}} END aliases and abbreviations


# {{{ functions
function fbook -d "find and open book from calibre library"
    set -l BOOK_PATH (find "$HOME/Calibre Library" -type f -not -name "*.opf" -not -name "*.jpg" | fzf --keep-right) &
    if test -f "$BOOK_PATH"
        zathura "$BOOK_PATH" &
        disown
    end
end

function take -d "Create a directory and set CWD" -a directory
    set -l DIR $argv[1]
    mkdir -p "$DIR"; and cd "$DIR"
end
# }}} END functions

# auto start sway after login on tty1
if test (tty) = /dev/tty1
    # what a display manager normally sets
    set -x XDG_SESSION_TYPE wayland
    set -x _JAVA_AWT_WM_NONREPARENTING 1
    set -x MOZ_ENABLE_WAYLAND 1
    exec sway
end
