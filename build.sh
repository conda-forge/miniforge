#!/usr/bin/env bash

set -ex

wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
chmod +x Miniconda3-latest-Linux-x86_64.sh
./Miniconda3-latest-Linux-x86_64.sh -b -p ${HOME}/miniconda3
__conda_setup="$($HOME'/miniconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f $HOME/miniconda3/etc/profile.d/conda.sh ]; then
        . $HOME/miniconda3/etc/profile.d/conda.sh
    else
        export PATH=$HOME/miniconda3/bin:$PATH
    fi
fi
unset __conda_setup
conda update --all --yes
conda config --add channels conda-forge
conda config --set show_channel_urls true
conda config --show
conda install constructor --yes

# Add a new version
echo version: `git describe --dirty` >> Miniforge3/construct.yaml
constructor --platform=linux-aarch64 Miniforge3
