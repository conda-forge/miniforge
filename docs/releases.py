"""Render a Miniforge releases page."""

from __future__ import annotations

import datetime
import sys
from pathlib import Path
from typing import Any

import jinja2
import requests_cache

HERE = Path(__file__).parent
BUILD = HERE.parent / "build"
DOCS = BUILD / "docs"

if not DOCS.exists():
    DOCS.mkdir(parents=True)

# TODO: handle pagination
BASE_URL = "https://api.github.com/repos/conda-forge/miniforge/releases?per_page=100"
ENV = jinja2.Environment(loader=jinja2.FileSystemLoader([HERE / "templates"]))


def get_releases() -> list[dict[str, Any]]:
    """Use the GitHub API to fetch release information."""
    s = requests_cache.CachedSession(str(BUILD / "cache"))
    releases = s.get(BASE_URL).json()

    new_releases = []

    for release in releases:
        if release["draft"] or release["prerelease"]:
            continue
        new_assets = []
        for asset in release["assets"]:
            name = asset["name"]
            if "sha256" in name:
                continue
            if release["tag_name"] not in name:
                continue
            if release["tag_name"] in asset["name"]:
                asset["_variant"], os_plat = asset["name"].split(
                    f"""-{release["tag_name"]}-"""
                )
                asset["_os"], asset["_arch"] = os_plat.split(".")[0].split("-")
            else:
                raise ValueError(f"Couldn't variant for {name}")
            asset["_sha256"] = s.get(
                f"""{asset["browser_download_url"]}.sha256"""
            ).text.split(" ")[0]
            new_assets += [asset]
        release["assets"] = new_assets
        new_releases += [release]
    releases = new_releases
    return releases


def render(releases: list[dict[str, Any]]) -> None:
    """Render the release page HTML."""
    context = {
        "title": "Miniforge Releases",
        "releases": releases,
        "year": datetime.datetime.now(tz=datetime.UTC).year,
    }
    html = ENV.get_template("all-releases.html").render(**context)

    release_html = DOCS / "all-releases" / "index.html"

    release_html.parent.mkdir(parents=True, exist_ok=True)

    release_html.write_text(html, encoding="utf-8")


def main() -> int:
    """Fetch the data and render the HTML."""
    releases = get_releases()
    render(releases)
    return 0


if __name__ == "__main__":
    sys.exit(main())
