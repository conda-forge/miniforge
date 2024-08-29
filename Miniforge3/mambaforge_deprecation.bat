if "%GITHUB_ACTIONS%"=="true" (
    echo ::warning title=Mambaforge is now deprecated!::Future Miniforge releases will NOT build Mambaforge installers. We advise you switch to Miniforge at your earliest convenience. More details at https://conda-forge.org/news/2024/07/29/sunsetting-mambaforge/. If you require mambaforge, you may pin your installer to one found from https://github.com/conda-forge/miniforge/releases/tag/24.5.0-1
)
else (
    msg "%sessionname%" Mambaforge is now deprecated! Future Miniforge releases will NOT build Mambaforge installers. We advise you switch to Miniforge at your earliest convenience. More details at https://conda-forge.org/news/2024/07/29/sunsetting-mambaforge/. If you require mambaforge, you may pin your installer to one found from https://github.com/conda-forge/miniforge/releases/tag/24.5.0-1
)

:REM for /f "delims=" %%# in ('powershell get-date -format "{yyyy-MM-dd}"') do @set _date=%%#
:REM if "%_date%"=="2024-10-01" exit 1
:REM if "%_date%"=="2024-10-15" exit 1
:REM if "%_date%"=="2024-11-01" exit 1
:REM if "%_date%"=="2024-11-10" exit 1
:REM if "%_date%"=="2024-11-20" exit 1
:REM if "%_date%"=="2024-11-30" exit 1
:REM if "%_date%"=="2024-12-05" exit 1
:REM if "%_date%"=="2024-12-10" exit 1
:REM if "%_date%"=="2024-12-15" exit 1
:REM if "%_date%"=="2024-12-20" exit 1
:REM if "%_date%"=="2024-12-25" exit 1
:REM if "%_date%"=="2024-12-30" exit 1
:REM if "%_date%"=="2024-12-31" exit 1
:REM if "%_date:~0,4%"=="2025"  exit 1
:REM
:REM echo Sleeping for 30s...
:REM powershell -nop -c "& {sleep 30}"
