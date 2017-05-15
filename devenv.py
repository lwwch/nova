#!/usr/bin/env python3
######################

"""
dev environment control
"""

import os
import subprocess

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
    with subprocess.Popen(
        cmd, shell=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT) as p:
        p.wait()
        stdout = p.stdout.read().decode()
        if p.returncode != 0:
            raise ValueError(stdout)
        return stdout

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

    vimdir = os.path.join(home, ".vim")
    backup(vimdir)
    link(vimdir, os.path.join(dots, "vim"))

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

    #
    #   fonts
    #

    fonts = "/usr/local/share/fonts/myles"
    backup(fonts)
    link(fonts, os.path.join(repo, "fonts"))
    # need to rebuild the font cache
    log("rebuilding the font cache...")
    call("sudo fc-cache -fv")

def set_terminal_theme(repo, name):

    theme = os.path.join(repo, "themes", name)
    with open(theme, "r") as fd:
        vals = linedict(":", fd)

    #
    #   just uses the default profile for now
    #

    profile_uuid = call("gsettings get org.gnome.Terminal.ProfilesList default")
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

    palatte = list(gcolor(vals["base%02x" % i]) for i in range(16))
    
    setkey("font",              "Hack 7")
    setkey("palatte",           palatte)
    setkey("foreground-color",  gcolor(vals["base05"]))
    setkey("background-color",  gcolor(vals["base00"]))

def main():

    from argparse import ArgumentParser
    p = ArgumentParser()
    args = p.parse_args()

    # NOTE: must be run from the root of the devenv git repo
    repo = os.path.join(
        os.getcwd())

    #
    #   main actions:
    #
    #   [x] link any dotfiles not already linked into this repo
    #   [ ] detect changes for any files that were copied vs linked,
    #       so they can be pushed back to github if needed?
    #   [x] apply theme to terminal, generate color scheme files if needed
    #   [ ] restart any processes/services to use the new files
    #

    link_dotfiles(repo)
    set_terminal_theme(repo, "void")

if __name__ == "__main__":
    main()
