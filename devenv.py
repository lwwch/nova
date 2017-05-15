#!/usr/bin/env python3
######################

"""
dev environment control
"""

def main():

    from argparse import ArgumentParser
    p = ArgumentParser()
    args = p.parse_args()

    #
    #   main actions:
    #
    #   - link any dotfiles not already linked into this repo
    #   - detect changes for any files that were copied vs linked,
    #     so they can be pushed back to github if needed
    #   - apply theme to terminal, generate color scheme files if needed
    #   - restart any processes/services to use the new files
    #

if __name__ == "__main__":
    main()
