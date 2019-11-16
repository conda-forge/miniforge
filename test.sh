#!/usr/bin/env bash

set -e

export CONDA_PATH="$HOME/miniforge"

echo "* Install dependencies"
if [ -f /etc/redhat-release ]; then
  yum install -y bzip2
fi

if [ -f /etc/lsb-release ]; then
  apt install -y bzip2
fi

cd /construct

echo "* Get the installer"
INSTALLER_PATH=$(find build/ -name "Miniforge*$ARCH.sh" | head -n 1)

echo "* Run the installer"
chmod +x $INSTALLER_PATH
bash $INSTALLER_PATH -b -p $CONDA_PATH

echo "* Setup conda"
$CONDA_PATH/bin/conda 'shell.bash' 'hook' 2> /dev/null

echo "* Print conda info"
conda info

echo "* Run conda update"
conda update --all -y

echo "* Python path"
which python

echo "* Print system informations from Python"
python -c "print('Hello Miniforge !')"
python -c "import platform; print(platform.architecture())"
python -c "import platform; print(platform.system())"
python -c "import platform; print(platform.machine())"
python -c "import platform; print(platform.release())"
