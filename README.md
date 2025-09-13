# misc-files

[![Periodic updates](https://github.com/AOSC-Dev/misc-files/actions/workflows/periodic-update.yml/badge.svg)](https://github.com/AOSC-Dev/misc-files/actions/workflows/periodic-update.yml)

Repository for miscellaneous files frequently overwritten by upstreams.

This repository is driven by the tracking list file `files.list` and utilizes GitHub Actions to keep files updated. Files in this repository are being used by the following packages:

- `iana-etc`: 
  - `/usr/share/iana-etc/port-numbers.iana`
  - `/usr/share/iana-etc/protocol-numbers.iana`
- `bind` (Not currently referenced by autobuild scripts)

## `files.list`

This file tells what file should be tracked by which package and renamed in the following format:

```
package-name url [file-name]
```

Example:

```
bind https://www.internic.net/zones/named.root
```

* package-name: The name of the package to which the file belongs
* url: The URL to download the file from
* file-name: Optional, will default to `$(basename $url)` if not provided

## How the workflow works?

The main workflow `periodic-update` is triggered under the following conditions:

- Update `files.list` on branch `master`
- Cron `"0 0 * * *"`
- Manually triggered by maintainers

When triggered, the workflow:

1. Parses `files.list` to determine which files to download.
2. Downloads each file, optionally renames each file, and calculates its checksums.
3. If changes are detected:
   - Commits the updates directly to the `master` branch
   - Then syncs the updated files to their package-specific branch (e.g. `iana-etc`)
   - Tags the commit in that branch with the current date (e.g. `iana-etc-20250914`)
4. If no changes are detected, the commit step is skipped and the workflow exits without further action.

## License

The workflow itself is licensed under the MIT License. All other files originated from external sources are subject to their respective upstream license.
