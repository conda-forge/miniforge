#!/usr/bin/env python3
import os

# Only .bashrc and .profile should be in $HOME
assert sorted(os.listdir(os.environ['HOME'])) == ['.bashrc', '.profile']