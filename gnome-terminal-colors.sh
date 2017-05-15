#!/bin/bash
###########

profile=$(gsettings get org.gnome.Terminal.ProfilesList default)
echo "profile ${profile}"

profile=${profile:1:-1} # remove leading and trailing single quotes

gsettings set "org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$profile/" background-color "'rgb(0,0,0)'"
