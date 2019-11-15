#!/usr/bin/env bash

set -ex

cd /construct

INSTALLER_PATH=$(find build/ -name 'Miniforge*.sh' | head -n 1)

chmod +x $INSTALLER_PATH
bash $INSTALLER_PATH -b -p ${HOME}/conda

__conda_setup="$($HOME'/conda/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f $HOME/conda/etc/profile.d/conda.sh ]; then
        . $HOME/conda/etc/profile.d/conda.sh
    else
        export PATH=$HOME/conda/bin:$PATH
    fi
fi
unset __conda_setup

conda info

which python
python -c "print('Hello Miniforge !')"
python -c "import platform; print(platform.architecture())"
python -c "import platform; print(platform.system())"
python -c "import platform; print(platform.machine())"
python -c "import platform; print(platform.release())"