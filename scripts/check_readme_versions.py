#!/usr/bin/env python3
"""Check README version information against release inputs (Python 3.11+)."""

import os
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
        if name == 'uniffi' and len(versions) > 1:
            errors.append('Check UniFFI version alignment between bdk-dart, bdk-ffi, and uniffi-dart')
        continue
    rows = re.findall(rf'^\|\s*`{re.escape(name)}`\s*\|\s*([^|]+?)\s*\|\s*$', section, re.MULTILINE)
    if rows != versions:
        errors.append(f'README {name} row must contain version {versions[0]}')
dependency = manifest['dependencies']['bdk-ffi']
tag = dependency.get('tag')
rev = dependency.get('rev')
is_release = os.environ.get('GITHUB_REF', '').startswith('refs/tags/')
if is_release and not tag:
    errors.append('Tagged releases must pin bdk-ffi by tag in native/Cargo.toml')
if tag:
    link = f'https://github.com/bitcoindevkit/bdk-ffi/blob/{tag}/CHANGELOG.md'
    if f'[BDK FFI {tag} release notes]({link})' not in section:
        errors.append(f'README upstream release-notes link must point to {tag}')
elif rev:
    sources = [p.get('source', '') for p in lock['package'] if p['name'] == 'bdk-ffi']
    if len(sources) != 1 or f'?rev={rev}#' not in sources[0]:
        errors.append('Refresh native/Cargo.lock to match the bdk-ffi revision in native/Cargo.toml')
    else:
        commit = sources[0].rsplit('#', 1)[-1]
        link = f'https://github.com/bitcoindevkit/bdk-ffi/commit/{commit}'
        if f'[BDK FFI development commit]({link})' not in section:
            errors.append(f'README must identify the BDK FFI development commit: {link}')
    if re.search(r'https://github\.com/bitcoindevkit/bdk-ffi/blob/[^\s)]+/CHANGELOG\.md', section):
        errors.append('Replace the README upstream release-notes link with the development commit link for a rev pin')
else:
    errors.append('Pin bdk-ffi with a tag or revision in native/Cargo.toml')
if errors:
    raise SystemExit('\n'.join(errors))
print('README upstream versions match the release inputs')
