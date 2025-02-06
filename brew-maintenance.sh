#!/bin/bash
brew update
brew upgrade
brew cleanup --prune=all
brew autoremove
