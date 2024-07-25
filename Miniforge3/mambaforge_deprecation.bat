if "%GITHUB_ACTIONS%"=="true" (
    echo ::warning title=Mambaforge is now deprecated!::Future Miniforge releases will NOT build Mambaforge installers. We advise you switch to Miniforge at your earliest convenience.
)
else (
    msg "%sessionname%" Mambaforge is now deprecated! Future Miniforge releases will NOT build Mambaforge installers. We advise you switch to Miniforge at your earliest convenience.
)
echo Sleeping for 30s...
powershell -nop -c "& {sleep 30}"
