#!/usr/bin/env python3
import os

# .bash_logout could optionally be in $HOME, otherwise only .bashrc and .profile
home_contents = sorted(os.listdir(os.environ['HOME']))
if len(home_contents) == 3:
    assert home_contents == ['.bash_logout', '.bashrc', '.profile'], home_contents
else:
    assert home_contents == ['.bashrc', '.profile'], home_contents