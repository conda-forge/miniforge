#!/usr/bin/env python

import re
import requests
from packaging import version

def get_most_recent_version(name):
    request = requests.get(
        "https://api.anaconda.org/package/conda-forge/" + name
    )
    request.raise_for_status()

    pkg = max(
        request.json()["files"], key=lambda x: version.parse(x["version"])
    )
    return pkg["version"]

mamba_version = get_most_recent_version("mamba")
conda_auth_version = get_most_recent_version("conda-auth")

with open("Miniforge3/construct.yaml", "r") as f:
    content = f.read()

# Replace mamba version
content = re.sub(r"mamba [\d.]+$", f"mamba {mamba_version}", content, flags=re.M)
# Replace conda-auth version
content = re.sub(
    r'set conda_auth_version = "[\d.]+"',
    f'set conda_auth_version = "{conda_auth_version}"',
    content,
)

with open("Miniforge3/construct.yaml", "w") as f:
    f.write(content)
