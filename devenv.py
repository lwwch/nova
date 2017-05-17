#!/usr/bin/env python3
######################

"""
dev environment control
"""

import os
import re
import subprocess
from datetime import datetime

def log(fmt,*args):
    print(fmt % args)

def linedict(sep, fd):
    o = dict()
    while True:
        l = fd.readline()
        if not l: break
        l = l.strip()
        if l == "" or l.startswith("#"): continue
        k,v = l.split(sep,1)
        o[k.strip()] = v.strip()
    return o

def call(cmd,*args):
    cmd = cmd % args
    log(cmd)
    with subprocess.Popen(
        cmd, shell=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT) as p:
        p.wait()
        stdout = p.stdout.read().decode()
        if p.returncode != 0:
            raise ValueError(stdout)
        return stdout.strip()   # dont care about trailing newlines

def backup(path):

    if not os.path.exists(path):
        return

    if os.path.islink(path):
        real = os.path.realpath(path)
        log("removing symlink to %s", real)
        os.unlink(path)
    else:
        bak = path + ".bak"
        if os.path.exists(bak):
            raise FileExistsError(bak)
        log("backing up %s", bak)
        os.rename(path,bak)

def link(dst,src):

    if not os.path.exists(src):
        raise FileNotFoundError(src)

    dstdir = os.path.dirname(dst)
    if not os.path.exists(dstdir):
        os.makedirs(dstdir)

    log("linked to %s", src)
    os.symlink(src, dst)

def link_dotfiles(repo):

    dots = os.path.abspath(os.path.join(repo, "dotfiles"))
    home = os.path.abspath(os.getenv("HOME"))

    log("HOME     %s", home)
    log("DOTFILES %s", dots)

    #
    #   bash
    #
    
    bashrc = os.path.join(home, ".bashrc")
    backup(bashrc)
    link(bashrc, os.path.join(dots, "bashrc"))

    #
    #   vim
    #

    vimrc = os.path.join(home, ".vimrc")
    backup(vimrc)
    link(vimrc, os.path.join(dots, "vimrc"))

    vimdir = os.path.join(home, ".vim/colors")
    backup(vimdir)
    link(vimdir, os.path.join(dots, "vim-colors"))

    #
    #   tmux
    #

    tconf = os.path.join(home, ".tmux.conf")
    backup(tconf)
    link(tconf, os.path.join(dots, "tmux.conf"))

    #
    #   i3
    #

    i3 = os.path.join(home, ".config/i3/config")
    backup(i3)
    link(i3, os.path.join(dots, "i3.conf"))

    blocks = os.path.join(home, ".config/i3/blocks.conf")
    backup(blocks)
    link(blocks, os.path.join(dots, "i3blocks.conf"))

    #
    #   x stuff
    #

    xinit = os.path.join(home, ".xinitrc")
    backup(xinit)
    link(xinit, os.path.join(dots, "xinitrc"))

    xrs = os.path.join(home, ".Xresources")
    backup(xrs)
    link(xrs, os.path.join(dots, "Xresources"))

    #
    #   fonts
    #

    fonts = "/usr/local/share/fonts/myles"
    backup(fonts)
    link(fonts, os.path.join(repo, "fonts"))
    # need to rebuild the font cache
    log("rebuilding the font cache...")
    log("    actually, skipping. to rebuild manually:")
    log("    $ sudo fc-cache -fv")
    #call("sudo fc-cache -fv")

def set_terminal_theme(repo):

    theme = os.path.join(repo, "themes", name)
    with open(theme, "r") as fd:
        vals = linedict(":", fd)

    #
    #   just uses the default profile for now
    #

    profile_uuid = call("gsettings get org.gnome.Terminal.ProfilesList default")[1:-1]
    log("gnome-terminal profile %s", profile_uuid)

    path = "org.gnome.Terminal.Legacy.Profile:" + \
           ("/org/gnome/terminal/legacy/profiles:/:%s/" % profile_uuid)

    def setkey(key, value):
        call("gsettings set {path} {key} \"{value}\"".format(
            path    = path,
            key     = key,
            value   = value))

    def gcolor(hcol):
        r = int("0x" + hcol[0:2], 16)
        g = int("0x" + hcol[2:4], 16)
        b = int("0x" + hcol[4:6], 16)
        return """'rgb(%d,%d,%d)'""" % (r,g,b)

    # this is apparently the crazy order of colors required
    # to make gnome-terminal happy with respect to bolding, etc
    palette = list(gcolor(vals["base%02x" % i]) for i in [0,8,0xb,0xa,0xd,0xe,0xc,5,3,9,1,2,4,6,0xf,7])
    palette = "[" + ",".join(palette) + "]"
    
    setkey("font",                  "Hack 7")
    setkey("palette",               palette)
    setkey("foreground-color",      gcolor(vals["base07"]))
    setkey("background-color",      gcolor(vals["base00"]))
    setkey("bold-color",            gcolor(vals["base07"]))
    setkey("bold-color-same-as-fg", "true")
    setkey("use-theme-colors",      "false")
    setkey("use-system-font",       "false")

def boot_to_text():

    #
    #   my bootup process goes straight to console login without any greeters
    #

    grub = "/etc/default/grub"

    with open(grub, "r") as fd:
        src = fd.read()

    boot_mode = re.compile("GRUB_CMDLINE_LINUX_DEFAULT=\s*\"(.*?)\"")
    m = boot_mode.search(src)

    if m is None:
        raise ValueError("cannot find key in grub conf")

    if m.group(1) == "text":
        log("no need to modify grub")
        return
    raise ValueError("modification of grub not supported. value='%s'" % m.group(1))

def main():

    from argparse import ArgumentParser
    p = ArgumentParser()
    args = p.parse_args()

    # NOTE: must be run from the root of the devenv git repo
    repo = os.path.join(
        os.getcwd())

    link_dotfiles(repo)
    #set_terminal_theme(repo)
    boot_to_text()

if __name__ == "__main__":
    main()
