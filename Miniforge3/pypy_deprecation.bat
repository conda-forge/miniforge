@ECHO OFF
set "title=PyPy support is now deprecated!"
set "message=PyPy support is now deprecated! Future Miniforge releases will NOT build installers with PyPy in their base envonrment. We advise you switch to Miniforge at your earliest convenience. More details at https://conda-forge.org/news/2024/08/14/sunsetting-pypy/ If you require Mambaforge, you may pin your installer to one found in https://github.com/conda-forge/miniforge/releases/tag/24.7.1-0"
if "%GITHUB_ACTIONS%"=="true" (
    echo ::warning title=%title%::%message%
) else (
    powershell "(New-Object -ComObject Wscript.Shell).Popup('%message%',0,'%title%',0x30)" >NUL
)

for /f "delims=" %%# in ('powershell get-date -format "{yyyy-MM-dd}"') do @set _date=%%#
if "%_date%"=="2024-10-01" exit 1
if "%_date%"=="2024-10-15" exit 1
if "%_date%"=="2024-11-01" exit 1
if "%_date%"=="2024-11-10" exit 1
if "%_date%"=="2024-11-20" exit 1
if "%_date%"=="2024-11-30" exit 1
if "%_date%"=="2024-12-05" exit 1
if "%_date%"=="2024-12-10" exit 1
if "%_date%"=="2024-12-15" exit 1
if "%_date%"=="2024-12-20" exit 1
if "%_date%"=="2024-12-25" exit 1
if "%_date%"=="2024-12-30" exit 1
if "%_date%"=="2024-12-31" exit 1
if "%_date:~0,4%"=="2025"  exit 1

echo Sleeping for 30s...
powershell -c "& {sleep 30}"
