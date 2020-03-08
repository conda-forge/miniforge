#!/usr/bin/env python3
import subprocess

# Interactive mode in bash should have (base) in PS1
# -i requires stdin to be a tty, but we don't care. stderr is silenced to keep output clean.
assert subprocess.check_output([
    '/bin/bash', '-i', '-c',
    'echo $PS1'
], stderr=subprocess.DEVNULL).decode().startswith("(base)")