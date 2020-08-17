export PATH=$HOME/bin:/usr/local/bin:$PATH
# If you come from bash you might have to change your $PATH.

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="agnoster"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in ~/.oh-my-zsh/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS=true

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)
plugins+=(kubectl)

source $ZSH/oh-my-zsh.sh

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
}

tmux-main() {
    # silent run tmux to inquire current session_name
    current_session=`tmux has-session -t $session`

    # test if no session is opened
    if [ $? -ne 0 ]; then
    	echo "No current tmux session detected, initializing new"
    	tmux-custom-split
	sleep 2
    fi
    tmux attach-session -t $session
}

alias tmux-list="tmux list-session"
alias tmux-kill="tmux kill-session -t"
alias tmux-atta="tmux attach-session -t"

exit() {
    if [[ -z $TMUX ]]; then
        builtin exit
    else
        tmux detach
    fi
}

# if tmux is not defined open a tmux-main session
if [[ -z $TMUX ]]; then
    # tmux-main
    echo "Run tmux-main to start a tmux-session 4x4 split screen!"
fi

export PATH=~/.local/bin:$PATH

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
