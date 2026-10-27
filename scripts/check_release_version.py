#!/usr/bin/env python3
"""Check calendar release labels against package-manager-compatible versions."""
import datetime,json,os,tomllib
from pathlib import Path
root=Path(__file__).resolve().parent.parent
release=json.loads((root/'release.json').read_text())
date=datetime.date.fromisoformat(release['date']);build=release['build']
assert type(build) is int and build>0,'BUILD must be a positive integer'
assert release['release']==f"{date:%y.%m.%d}.{build}",'release name does not match date/build'
version=f"{date.year%100}.{date.month}.{date.day}-build.{build}"
assert release['package_version']==version,'package version does not match date/build'
assert release['stability']=='experimental','current release is experimental'
manifest=root/'Cargo.toml'
if manifest.exists():
 assert tomllib.loads(manifest.read_text())['package']['version']==version,'Cargo version mismatch'
 lock=tomllib.loads((root/'Cargo.lock').read_text())
 assert next(p for p in lock['package'] if p['name']=='erebine-rs')['version']==version,'lockfile version mismatch'
if os.environ.get('GITHUB_REF_TYPE')=='tag':
 assert os.environ.get('GITHUB_REF_NAME')==version,'release tag does not match package version'
print(f"Release {release['release']}; package/tag {version}: valid")
