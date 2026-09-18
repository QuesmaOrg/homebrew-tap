#!/usr/bin/env python3
"""Import the upstream release cask without rolling back a newer installed definition."""

import json
from pathlib import Path
import re
import sys


def version_key(version):
    match = re.fullmatch(r"(\d+)\.(\d+)\.(\d+)(?:-(\d+)\.[0-9a-f]+)?", version)
    if not match:
        raise ValueError(f"unexpected shipper version: {version!r}")
    major, minor, patch, counter = match.groups()
    return (int(major), int(minor), int(patch), int(counter) if counter else float("inf"))


def cask_version(text):
    match = re.search(r'^  version "([^"]+)"$', text, re.MULTILINE)
    if not match:
        raise ValueError("cask has no explicit version")
    return match[1]


def update(release, text, target):
    version = cask_version(text)
    if release["tag_name"] != version or release.get("draft") or release.get("prerelease"):
        raise ValueError("cask must match a published stable release")
    if not text.startswith('cask "quesma-shipper" do\n'):
        raise ValueError("unexpected cask name")
    candidate = version_key(version)
    if target.exists() and candidate < version_key(cask_version(target.read_text())):
        print("Keeping the newer cask already in the tap")
        return
    target.parent.mkdir(parents=True, exist_ok=True)
    target.write_text(text)


if __name__ == "__main__":
    if len(sys.argv) != 3:
        sys.exit("usage: update-shipper.py RELEASE_JSON CASK_FILE")
    update(json.loads(Path(sys.argv[1]).read_text()), Path(sys.argv[2]).read_text(), Path("Casks/quesma-shipper.rb"))
