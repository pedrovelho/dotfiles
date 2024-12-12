# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

ZSH_TMUX_AUTOSTART=false
ZSH_THEME="powerlevel10k/powerlevel10k"
ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )
plugins=(git)
plugins+=(kubectl)
plugins+=(tmux)
plugins+=(nix-shell)

source ~/.oh-my-zsh/oh-my-zsh.sh

# Added autocompletion to kubectl commands
if [  ]; then source <(kubectl completion zsh); fi

# tmux related stuff
session="main"
tmux-custom-split () {
    # create a detached session and call it main
    tmux new-session -t ${session} -d

    # split window
    tmux split-window -d -t 0 -p 50 -v
    tmux split-window -d -t 0 -p 50 -h
    tmux split-window -d -t 2 -p 50 -h

    # launch fancy fastfetch on top left
    #tmux send -t main-0:0.0 "fastfetch" C-m
}

tmux-main() {
    # silent run tmux to inquire current session_name
    current_session=`tmux has-session -t $session`

    # test if no session is opened
    if [ $? -ne 0 ]; then
    	tmux-custom-split
	sleep 2
    fi
    tmux attach-session -t $session
}

alias tmux-list="tmux list-session"
alias tmux-kill="tmux kill-session -t"
alias tmux-atta="tmux attach-session -t"
alias ls='lsd'
#alias cat='bat'
alias du='dust'
eval $(thefuck --alias)

exit() {
    if [[ -z "${TMUX}" ]] then
        builtin exit
    else
	if [[ -v POETRY_ACTIVE ]]; then
	    builtin exit
	else
	    tmux detach
        fi
    fi
}

export PATH=~/.local/bin:$PATH

# Make spark work on nix
export SPARK_HOME="/run/current-system/sw"


# Configure default nodejs version for all sessions
# nvm use 10.16.1

alias ryax_clean='docker-compose down -v && sudo rm -fr /var/lib/ryax/* && sudo rm -r /var/lib/ryax/.*'
alias ryax_detection='./cli/ryax-cli --server=localhost/api login && \
./cli/ryax-cli --server=localhost/api function create ~/IdeaProjects/object_detection/funcs/* && \
ls -1 ~/IdeaProjects/object_detection/funcs/ | while read func ; do ./cli/ryax-cli --server=localhost/api function build $func-1.0 ; done && \
ls -1 ~/IdeaProjects/object_detection/funcs/ | while read func ; do ./cli/ryax-cli --server=localhost/api function build $func-1.0 ; done'

alias config-registry="source <(pass ryax/aws-s3)"
alias allpods="kubectl get pods --all-namespaces"
alias delryaxpod="kubectl unapply pod -n ryaxns"
alias win="VirtualBoxVM --startvm \"Win\""

function watcha {
    watch $(alias "$@" | cut -d\' -f2)
}

delpodbyname () {
    delryaxpod `allpods -o json --selector=app=$1 | jq -r '.items[0].metadata.name'`
}

export NO_AT_BRIDGE=1

ryax-exterminate () {
    for fbid in `./ryax-cli -o json --server=localhost/api $1 list | jq -r .[].id` ; do
        ./ryax-cli --server=localhost/api $1 delete $fbid
    done
}

ryax-stop-all () {
    for fbid in `./ryax-cli -o json --server=localhost/api wdeploy list | jq -r .[].id` ; do
        ./ryax-cli --server=localhost/api wdeploy stop $fbid
    done
}

ryax-delete-all () {
    ryax-stop-all
    for fbid in "wdeploy" "wdraft" "fb" "fd" "fdeploy" ; do
        ryax-exterminate $fbid
    done
}

killp () {
    kill -9 `pgrep $1`
}

autoload -Uz compinit
zstyle ':completion:*' menu select
fpath+=~/.zfunc

export KUBE_EDITOR=emacs

nix-clean () {
  nix-env --delete-generations old
  nix-store --gc
  nix-channel --update
  nix-env -u --always
  for link in /nix/var/nix/gcroots/auto/*
  do
    rm $(readlink "$link")
  done
  nix-collect-garbage -d
}

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

export PATH=~/.bin:$PATH

alias start-jellyfin="docker run --name jellyfin --rm -p 8096:8096 -v /home/velho/varzia/jellyfin/jellyfin-config:/config -v /home/velho/varzia/jellyfin/jellyfin-library:/media -v /home/velho/varzia/jellyfin/jellyfin-cache:/cache docker.io/linuxserver/jellyfin:10.9.4"
#alias start-jellyfin="docker run --name jellyfin --rm -p 8096:8096 -v /home/velho/varzia/jellyfin/jellyfin-config:/config -v /home/velho/varzia/jellyfin/jellyfin-library:/data   velho/jellyfin"

export LD_LIBRARY_PATH=$(dirname $(gcc -print-file-name=libstdc++.so.6))

alias pixelborn='/home/velho/nvidia-offload.sh wine64 /home/velho/Games/Pixelborn/Pixelborn.exe'

# Tested with ====>

# /home/velho/nvidia-offload.sh glxinfo | grep "OpenGL renderer"
# OpenGL renderer string: NVIDIA GeForce GTX 1650 Ti with Max-Q Design/PCIe/SSE2

# glxinfo | grep "OpenGL renderer"
# OpenGL renderer string: Mesa Intel(R) UHD Graphics (CML GT2)

alias nvidia-offload='/home/velho/nvidia-offload.sh'
alias gpu-offload='/home/velho/nvidia-offload.sh'
