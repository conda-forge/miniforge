#!/usr/bin/env bash

set -ex

echo "***** Start: Testing Miniforge installer *****"

CONSTRUCT_ROOT="${CONSTRUCT_ROOT:-${PWD}}"
cd "${CONSTRUCT_ROOT}"

export CONDA_PATH="${HOME}/miniforge"
MAMBA_VERSION=$(grep "set mamba_version" Miniforge3/construct.yaml | cut -d '=' -f 2 | cut -d '"' -f 2)
export MAMBA_VERSION

echo "***** Get the installer *****"
ls build/
if [[ "$(uname)" == MINGW* ]]; then
   EXT="exe";
else
   EXT="sh";
fi
INSTALLER_PATH=$(find build/ -name "*forge*.${EXT}" | head -n 1)
INSTALLER_NAME=$(basename "${INSTALLER_PATH}" | cut -d "-" -f 1)

echo "***** Run the installer *****"
chmod +x "${INSTALLER_PATH}"
if [[ "$(uname)" == MINGW* ]]; then
  echo "start /wait \"\" ${INSTALLER_PATH} /InstallationType=JustMe /RegisterPython=0 /S /D=$(cygpath -w "${CONDA_PATH}")" > install.bat
  cmd.exe //c install.bat

  echo "***** Setup conda *****"
  # Workaround a conda bug where it uses Unix style separators, but MinGW doesn't understand them
  # we need condabin in PATH for both conda and mamba
  export PATH=$CONDA_PATH/Library/bin:$PATH
  # shellcheck disable=SC1091
  eval "$("$CONDA_PATH/python.exe" -m conda shell.posix hook)"
  eval "$("$CONDA_PATH/Library/bin/mamba.exe" shell hook)"
  conda config --set show_channel_urls true

  echo "***** Print conda info *****"
  conda info
  conda list
  conda info --envs
  conda config --show-sources

  echo "***** Check if we are bundling packages from msys2 or defaults *****"
  conda list | grep defaults && exit 1
  conda list | grep msys2 && exit 1

  echo "***** Check if we can install a package which requires msys2 *****"
  conda install r-base --yes --quiet
  conda list
else
  # Test one of our installers in batch mode
  if [[ "${INSTALLER_NAME}" == "Miniforge3" ]]; then
    sh "${INSTALLER_PATH}" -b -p "${CONDA_PATH}"
  # And the other in interactive mode
  else
    # Test interactive install. The install will ask the user to
    # - newline -- read the EULA
    # - yes -- then accept
    # - ${CONDA_PATH} -- Then specify the path
    # - no -- Then whether or not they want to initialize conda
    cat <<EOF | sh "${INSTALLER_PATH}"

yes
${CONDA_PATH}
no
EOF
  fi

  echo "***** Setup conda *****"
  # shellcheck disable=SC1091
  eval "$("$CONDA_PATH/bin/python" -m conda shell.posix hook)"
  eval "$("$CONDA_PATH/bin/mamba" shell hook)"

  echo "***** Print conda info *****"
  conda info
  conda list
  conda info --envs
  conda config --show-sources
fi

set +x

echo "+ Mamba does not warn (check that there is no warning on stderr) and returns exit code 0"
mamba --help 2> stderr.log || cat stderr.log
test ! -s stderr.log
rm -f stderr.log

echo "+ mamba info"
mamba info

echo "+ mamba config sources"
mamba config sources

echo "+ mamba config list"
mamba config list

echo "+ Testing mamba version (i.e. ${MAMBA_VERSION})"
mamba info --json | python -c "import sys, json; info = json.loads(sys.stdin.read()); assert info['mamba version'] == '${MAMBA_VERSION}', info"
echo "  OK"

MINIFORGE_CHANNEL_NAME="${MINIFORGE_CHANNEL_NAME:-conda-forge}"
echo "+ Testing mamba channels"
mamba info --json | python -c "import sys, json; info = json.loads(sys.stdin.read()); assert any('${MINIFORGE_CHANNEL_NAME}' in c for c in info['channels']), info"
echo "  OK"

set -x

echo "***** Python path *****"
# These tests use Python, which does need an active environment

conda activate

python -c "import sys; print(sys.executable)"
python -c "import sys; assert 'miniforge' in sys.executable"

echo "***** Print system informations from Python *****"
python -c "print('Hello Miniforge !')"
python -c "import platform; print(platform.architecture())"
python -c "import platform; print(platform.system())"
python -c "import platform; print(platform.machine())"
python -c "import platform; print(platform.release())"

conda deactivate

echo "***** Check default environment *****"

conda activate
default_prefix_nameless="$CONDA_PREFIX"
echo "default_prefix_nameless=$default_prefix_nameless"
default_python_nameless="$(type python)"
echo "default_python_nameless=$default_python_nameless"
python -V
conda deactivate

conda activate default
default_prefix="$CONDA_PREFIX"
echo "default_prefix=$default_prefix"
default_python="$(type python)"
echo "default_python=$default_python"
python -V
conda deactivate

test "$default_prefix_nameless" = "$default_prefix"
test "$default_python_nameless" = "$default_python"

echo "***** Done: Testing installer *****"

echo "***** Testing the usage of mamba main commands *****"

echo "***** Initialize the current session for mamba *****"
eval "$(mamba shell hook --shell bash)"

echo "***** Create a new environment *****"
ENV_PREFIX="/tmp/testenv"

mamba create -p $ENV_PREFIX numpy --yes -vvv

echo "***** Activate the environment with mamba *****"
mamba activate $ENV_PREFIX

echo "***** Check that numpy is installed with mamba list *****"
mamba list | grep numpy

echo "***** Deactivate the environment *****"
mamba deactivate

echo "***** Activate the environment with conda *****"
conda activate $ENV_PREFIX

echo "***** Check that numpy is installed with python *****"
python -c "import numpy; print(numpy.__version__)"

echo "***** Remove numpy *****"
mamba remove numpy --yes

echo "***** Check that numpy is not installed with mamba list *****"
mamba list | grep -v numpy

echo "***** Deactivate the environment with conda *****"
conda deactivate

echo "***** Remove the environment *****"
mamba env remove -p $ENV_PREFIX --yes

echo "***** Done: Testing mamba main commands *****"

