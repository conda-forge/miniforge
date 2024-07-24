#!/bin/bash

if "$GITHUB_ACTIONS"=="1" (
    echo ::warning title=Mambaforge is now deprecated!::Future Miniforge releases will NOT build Mambaforge installers. We advise you switch to Miniforge at your earliest convenience.
)
else (
    msg "%sessionname%" Mambaforge is now deprecated! Future Miniforge releases will NOT build Mambaforge installers. We advise you switch to Miniforge at your earliest convenience.
    timeout /t 30 /nobreak
)
