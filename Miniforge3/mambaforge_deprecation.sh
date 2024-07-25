#!/bin/bash

if [[ "$GITHUB_ACTIONS" == "true" ]]; then
    echo "::warning title=Mambaforge is now deprecated!::Future Miniforge releases will NOT build Mambaforge installers. We advise you switch to Miniforge at your earliest convenience. More details at https://conda-forge.org/news/2024/07/29/sunsetting-mambaforge/."
else
    echo "!!!!!! Mambaforge is now deprecated !!!!!"
    echo "Future Miniforge releases will NOT build Mambaforge installers."
    echo "We advise you switch to Miniforge at your earliest convenience."
    echo "More details at https://conda-forge.org/news/2024/07/29/sunsetting-mambaforge/."
fi

case $(date +%F) in 
    # Brownouts
    2024-10-01|2024-10-15|2024-11-01|2024-11-10|2024-11-20|2024-11-30|2024-12-05|2024-12-10|2024-12-15|2024-12-20|2024-12-25|2024-12-30|2024-12-31|2025-*)
        exit 1
    ;;
    *)
        echo "Sleeping for 30s..."
        sleep 30
    ;;
esac
