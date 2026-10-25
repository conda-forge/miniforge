"%PREFIX%\python.exe" -m conda install -p "%PREFIX%" --offline --force-reinstall --no-deps --yes conda-launchers
if errorlevel 1 exit 1
