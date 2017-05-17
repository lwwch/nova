#!/bin/bash
###########

killall polybar
polybar default -c ${HOME}/.polybar &> poly.log &
