#!/usr/bin/env python3
"""Check README version information against release inputs (Python 3.11+)."""

import pathlib
import re
import tomllib

readme = pathlib.Path('README.md').read_text()
section = re.search(r'^## Upstream versions\s*\n(.*?)(?=^## |\Z)', readme, re.MULTILINE | re.DOTALL)
if section is None:
    raise SystemExit('README.md is missing the Upstream versions section')
section = section.group(1)
manifest = tomllib.loads(pathlib.Path('native/Cargo.toml').read_text())
lock = tomllib.loads(pathlib.Path('native/Cargo.lock').read_text())
errors = []
package_version = manifest['package']['version']
pubspec = pathlib.Path('pubspec.yaml').read_text()
if not re.search(rf'^version:\s*{re.escape(package_version)}\s*$', pubspec, re.MULTILINE):
    errors.append('native/Cargo.toml package version must match pubspec.yaml')
if f'`bdk_dart` **{package_version}**' not in section:
    errors.append(f'README BDK Dart version must be {package_version}')
for name in ('bdk-ffi', 'bdk_wallet', 'bdk_electrum', 'bdk_esplora', 'bdk_kyoto', 'uniffi'):
    versions = [p['version'] for p in lock['package'] if p['name'] == name]
    if len(versions) != 1:
        errors.append(f'Expected one {name} version in native/Cargo.lock; found {versions}')
        continue
    rows = re.findall(rf'^\|\s*`{re.escape(name)}`\s*\|\s*([^|]+?)\s*\|\s*$', section, re.MULTILINE)
    if rows != versions:
        errors.append(f'README {name} row must contain version {versions[0]}')
tag = manifest['dependencies']['bdk-ffi'].get('tag')
if not tag:
    errors.append('Release dependency bdk-ffi must use a tag in native/Cargo.toml')
else:
    link = f'https://github.com/bitcoindevkit/bdk-ffi/blob/{tag}/CHANGELOG.md'
    if f'[BDK FFI {tag} release notes]({link})' not in section:
        errors.append(f'README upstream release-notes link must point to {tag}')
if errors:
    raise SystemExit('\n'.join(errors))
print('README upstream versions match the release inputs')
