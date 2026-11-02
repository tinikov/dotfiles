# Template for ~/.config/fish.local.fish: machine-local fish settings, sourced last by
# config.fish. Copy only what this machine needs.

# ---------- Linux (HPC) ----------
# `module` is a bash function, so it doesn't survive the switch to fish
# (the environment it set up does); load the fish version to use it interactively.
# if set -q MODULESHOME; and test -f $MODULESHOME/init/fish
#     source $MODULESHOME/init/fish
# end

# Shortcuts for this machine
# alias qcd "cd /path/to/work"

# A fish glob that matches nothing is an error, so collect the matches first
# function lcl --description 'Remove job output files'
#     set -l files *.job.e* *.job.o*
#     test (count $files) -gt 0; and command rm $files
# end

# ---------- macOS ----------
# Usually nothing: the shared config already covers macOS.
