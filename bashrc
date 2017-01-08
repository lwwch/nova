# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
export TERM=screen-256color

__display_ret_code() {
    local ret=$1
    [ $ret -eq 0 ] && printf "\[\e[38;5;242m\](%3s)\[\e[0m\]" $ret && return
    printf "\[\e[38;5;124m\](%3s)\[\e[0m\]" $ret
}

__display_user_at_host() {
    echo " \[\e[38;5;238m\]\u@\h\[\e[0m\]"
}

__display_working_dir() {
    printf "\[\e[38;5;241m\] \w \[\e[0m\]"
}

__display_git() {
    local raw=$(git status 2>/dev/null | head -1)
    [ "$raw" == "" ] && return
    if [ "$raw" == "# Not currently on any branch." ]; then
        # display tag
        local tag=$(git log -n1 --pretty=format:%d | tr -d ' ' | tr -d '(' | tr -d ')')
        printf "\[\e[38;5;247m\]%s \[\e[m\]" "$tag"
    else
        # display branch
        local branch=$(echo "$raw" | awk '{print $3}')
        printf "\[\e[38;5;247m\]%s \[\e[m\]" $branch
    fi
    # display dirty / clean
    local status=$(git status -s)
    local check=$(echo -e '\u2713')
    local ex=$(echo -e '\u2717')
    [ "$status" == "" ] && printf "\[\e[38;5;244m\]%s \[\e[0m\]" $check && return
    local symbol=$(echo -e '\u2718')
    printf "\[\e[38;5;124m\]%s \[\e[0m\]" $symbol
}

__generate_prompt() {
    PS1="$(__display_ret_code $?)$(__display_user_at_host)$(__display_working_dir)$(__display_git) "
}

export PROMPT_COMMAND=__generate_prompt

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

#
#   Git Aliases
#

alias gl="git log --color --graph --abbrev-commit --pretty=format:'%Cred%h%Creset -%Creset% Cgreen(%cr) %C(bold blue)%an%C(yellow)%d%Creset %s'"
alias gla="git log --all --color --graph --abbrev-commit --pretty=format:'%Cred%h%Creset -%Creset% Cgreen(%cr) %C(bold blue)%an%C(yellow)%d%Creset %s'"
alias gs='git status'

#
#   Conda
#

export PATH="/home/myles/software/conda/bin:$PATH"
. activate dev35

#
#   altera
#

export ALTERAOCLSDKROOT="/home/myles/software/altera/16.0/hld"
export QSYS_ROOTDIR="/home/myles/altera_lite/16.0/quartus/sopc_builder/bin"
