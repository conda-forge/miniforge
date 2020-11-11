#!/usr/bin/env bash

set -ex

echo "***** Start: Testing Miniforge installer *****"

export CONDA_PATH="$HOME/miniforge"

CONSTRUCT_ROOT="${CONSTRUCT_ROOT:-$PWD}"

cd ${CONSTRUCT_ROOT}

echo "***** Get the installer *****"
INSTALLER_PATH=$(find build/ -name "Miniforge*.sh" -or -name "Miniforge*.exe"| head -n 1)

echo "***** Run the installer *****"
chmod +x $INSTALLER_PATH
if [[ "$(uname)" == MSYS* ]]; then
  echo "start /wait \"\" build/Miniforge3-4.9.0-0-Windows-x86_64.exe /InstallationType=JustMe /RegisterPython=0 /S /D=$(cygpath -w $CONDA_PATH)" > install.bat
  cmd.exe /c install.bat

  echo "***** Setup conda *****"
  source $CONDA_PATH/Scripts/activate

  echo "***** Print conda info *****"
  conda.exe info
else
  bash $INSTALLER_PATH -b -p $CONDA_PATH

  echo "***** Setup conda *****"
  source $CONDA_PATH/bin/activate

  echo "***** Print conda info *****"
  conda info
fi


# 2020/09/15: Running conda update switches from pypy to cpython. Not sure why
# echo "***** Run conda update *****"
# conda update --all -y

echo "***** Python path *****"
python -c "import sys; print(sys.executable)"
python -c "import sys; assert 'miniforge' in sys.executable"

echo "***** Print system informations from Python *****"
python -c "print('Hello Miniforge !')"
python -c "import platform; print(platform.architecture())"
python -c "import platform; print(platform.system())"
python -c "import platform; print(platform.machine())"
python -c "import platform; print(platform.release())"

echo "***** Done: Testing installer *****"
