# {{{ shell utils setup
set -U fish_greeting # suppress default greeting
starship init fish | source
fzf_key_bindings

zoxide init fish | source
function fzf-z -d "fuzzy search recent dirs"
    _ZO_FZF_OPTS='--height 40% --layout=reverse' zi
end
bind \cg fzf-z

set -x ASDF_CONFIG_FILE "$HOME/.config/asdfrc"
source /opt/asdf-vm/asdf.fish
# }}} END shell utils setup


# {{{ language env set up
fish_add_path "$HOME/.local/bin" # pip
fish_add_path "$HOME/.poetry/bin" # poetry
fish_add_path "(ruby -e 'puts Gem.user_dir')/bin" # ruby
fish_add_path "$HOME/.npm_global/bin" # npm
fish_add_path "$HOME/.yarn/bin" # yarn
fish_add_path "$HOME/.cargo/bin" # rust

set -x GOPATH "$HOME/go/bin"
set -x GOROOT /usr/lib/go
fish_add_path "$GOPATH" "$GOROOT"

set -x ANDROID_HOME "$HOME/Android/Sdk"
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
# }}} END misc config


# {{{ aliases and abbreviations
set -x EDITOR nvim
abbr -a -- v "$EDITOR"
abbr -a -- g git

alias sizes="du -csh * | sort -h"
alias whoslistening="ss -lntu"
alias vw="$EDITOR -c VimwikiIndex"
alias vwt="$EDITOR -c VimwikiMakeDiaryNote"
alias shopping_list="$EDITOR $HOME/Documents/shopping-lists/(date --iso-8601).md"

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
    set -l BOOK_PATH (find "$HOME/Calibre Library" -type f | fzf) &
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
