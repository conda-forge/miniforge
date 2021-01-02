"""render a miniforge releases page"""
import jinja2
from pathlib import Path
import datetime
import sys
import requests_cache

HERE = Path(__file__).parent
BUILD = HERE.parent / "build"
DOCS = BUILD / "docs"

if not DOCS.exists():
    DOCS.mkdir(parents=True)

# TODO: handle pagination
BASE_URL = "https://api.github.com/repos/conda-forge/miniforge/releases?per_page=100"
ENV = jinja2.Environment(loader=jinja2.FileSystemLoader([HERE / "templates"]))


def get_releases():
    """use the GitHub API to fetch release information"""
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


def render(releases):
    """render the release page HTML"""
    context = dict(
        title="Miniforge Releases", releases=releases, year=datetime.datetime.now().year
    )
    html = ENV.get_template("all-releases.html").render(**context)

    release_html = DOCS / "all-releases" / "index.html"

    if not release_html.parent.exists():
        release_html.parent.mkdir(parents=True)

    release_html.write_text(html, encoding="utf-8")


def main():
    """main entrypoint"""
    releases = get_releases()
    render(releases)
    return 0


if __name__ == "__main__":
    sys.exit(main())
