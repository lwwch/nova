#!/bin/bash
###########
#
#   entry point for dev env control
#

#
#   utils
#

error()
{
    echo "ERROR: $@"
    exit 1
}

#
#   commands
#

command_check()
{
    error "not implemented"
}

link_dotfiles()
{
    return 0
}

theme_terminal()
{
    local PROFILE=$(gsettings get org.gnome.Terminal.ProfilesList default)
    PROFILE=${PROFILE:1-1}
    echo "using gnome-terminal profile ${PROFILE}"

    local PROFILE_BASE="org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:${PROFILE}"
    
    gsettings set ${PROFILE_BASE} palatte

gsettings set "org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$profile/" background-color "'rgb(0,0,0)'"
}

command_apply()
{
    echo "applying devenv..."

    echo "INSTALLING PACKAGES..."
    sudo apt-get install -y $(grep -vE '^#' ./packages)

    echo "APPLYING DOTFILES..."
    link_dotfiles

    echo "APPLYING THEME..."
    theme_terminal void
}

#
#   main/entry
#

usage()
{
    echo "usage:"
    echo "    bash builder.sh [options] COMMAND"
    echo "where [options] is one of:"
    echo "    --theme       theme to use (default: void)"
    echo "and COMMAND is one of:"
    echo "    check         checks for updates to files that need committing"
    echo "    apply         applies dotfiles & themes to current system, installs packages, etc"
}

usage_error()
{
    usage
    error "$@"
}

main()
{
    [ $# -lt 1 ] && usage_error "not enough arguments"

    while (( $# )); do
        case $1 in
            check)
                command_check
                ;;
            apply)
                command_apply
                ;;
            *)
                usage_error "unknown command '$1'"
                ;;
        esac
        shift
    done
}

main "$@"
