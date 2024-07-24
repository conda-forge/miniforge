#!/bin/bash

if [[ "$GITHUB_ACTIONS" == "1"]];
    echo "::warning title=Mambaforge is now deprecated!::Future Miniforge releases will NOT build Mambaforge installers. We advise you switch to Miniforge at your earliest convenience."
else
    echo "!!!!!! Mambaforge is now deprecated !!!!!"
    echo "Future Miniforge releases will NOT build Mambaforge installers."
    echo "We advise you switch to Miniforge at your earliest convenience."
    echo "Sleeping for 30s..."
    sleep 30
fi
