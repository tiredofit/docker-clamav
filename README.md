# nfrastack/container-clamav

## About

This repository will build a container with [Clam Antivirus](https://www.clamav.net) to scan files or mail messages.

* Auto Configuration Support
* Automatic Downlad and update of Virus Definitions
* Ability to load custom definitions

## Maintainer

- [Nfrastack](https://www.nfrastack.com)

## Table of Contents

- [About](#about)
- [Maintainer](#maintainer)
- [Table of Contents](#table-of-contents)
- [Installation](#installation)
  - [Prebuilt Images](#prebuilt-images)
  - [Quick Start](#quick-start)
  - [Persistent Storage](#persistent-storage)
- [Configuration](#configuration)
  - [Environment Variables](#environment-variables)
    - [Base Images used](#base-images-used)
    - [Core Configuration](#core-configuration)
    - [Virus Definitions Configuration](#virus-definitions-configuration)
    - [Virus Scanning Settings](#virus-scanning-settings)
    - [Scanning Limits](#scanning-limits)
    - [Alerting Settings](#alerting-settings)
  - [Users and Groups](#users-and-groups)
  - [Networking](#networking)
- [Maintenance](#maintenance)
  - [Shell Access](#shell-access)
  - [Manual Definition Updates](#manual-definition-updates)
- [Support & Maintenance](#support--maintenance)
- [License](#license)

## Installation

### Prebuilt Images

Feature limited builds of the image are available on the [Github Container Registry](https://github.com/nfrastack/container-clamav/pkgs/container/container-clamav) and [Docker Hub](https://hub.docker.com/r/nfrastack/clamav).

To unlock advanced features, one must provide a code to be able to change specific environment variables from defaults. Support the development to gain access to a code.

To get access to the image use your container orchestrator to pull from the following locations:

```
ghcr.io/nfrastack/container-clamav:(image_tag)
docker.io/nfrastack/clamav:(image_tag)
```

Image tag syntax is:
- <image>:<optional tag>-<optional_distribution>_<optional_distribution_variant>

Example:
         - `ghcr.io/nfrastack/container-clamav:latest` or
         - `ghcr.io/nfrastack/container-clamav:1.0` or
         - `ghcr.io/nfrastack/container-clamav:1.0-alpine` or
         - `ghcr.io/nfrastack/container-clamav:alpine` or
         - `ghcr.io/nfrastack/container-clamav:debian`

* `latest` will be the most recent commit
* An otpional `tag` may exist that matches the [CHANGELOG](CHANGELOG.md) - These are the safest
* If it is built for multiple distributions there may exist a value of `alpine` or `debian`
* If there are multiple distribution variations it may include a version - see the registry for availability

Have a look at the container registries see what tags are available.

#### Multi-Architecture Support

Images are built for `amd64` by default, with optional support for `arm64` and other architectures.

### Quick Start

* The quickest way to get started is using [docker-compose](https://docs.docker.com/compose/). See the examples folder for a working [compose.yml](examples/compose.yml) that can be modified for your use.

* Map [persistent storage](#persistent-storage) for access to configuration and data files for backup.
* Set various [environment variables](#environment-variables) to understand the capabilities of this image.

### Persistent Storage

The following directories are used for configuration and can be mapped for persistent storage.

| Directory | Description           |
| --------- | --------------------- |
| `/config` | Configuration Files   |
| `/data`   | AntiVirus Definitions |
| `/logs`   | Log Files             |

### Environment Variables

#### Base Images used

This image relies on a customized base image in order to work.
Be sure to view the following repositories to understand all the customizable options:

| Image                                                   | Description |
| ------------------------------------------------------- | ----------- |
| [OS Base](https://github.com/nfrastack/container-base/) | Base Image  |

Below is the complete list of available options that can be used to customize your installation.

* Variables showing an 'x' under the `Advanced` column can only be set if the containers advanced functionality is enabled.

#### Core Configuration

| Parameter              | Description                                                            | Default              | Advanced |
| ---------------------- | ---------------------------------------------------------------------- | -------------------- | -------- |
| `CLAMAV_SETUP_TYPE`    | Auto Configure Configuration each startup - Set to `MANUAL` to disable | `AUTO`               |          |
| `CLAMD_SETUP_TYPE`     | Auto Configure ClamD configuration each startup                        | `$CLAMAV_SETUP_TYPE` |          |
| `FRESHCLAM_SETUP_TYPE` | Auto Configure ClamD configuration each startup                        | `$CLAMAV_SETUP_TYPE` |          |
| `CONFIG_PATH`          | Folder for Config Files                                                | `/config/`           |          |
| `DATA_PATH`            | Base Folder for Data Files                                             | `/data/`             |          |
| `DEFINITIONS_PATH`     | Folder for Virus Definitions                                           | `${DATA_PATH}`       |          |
| `CLAMD_CONFIG_FILE`    | Clamd Configuration file                                               | `clamd.conf`         |          |
| `LOG_TYPE`             | Log to `file`, `console`, `both`, or `none`                            | `FILE`               |          |
| `LOG_PATH`             | Logfile locations                                                      | `/logs/`             |          |
| `LOG_DEBUG`            | Enable Debug in Logs                                                   | `FALSE`              |          |
| `LOG_EXTENDED_INFO`    | Place extended informationin logs when virus found                     | `TRUE`               |          |
| `LOG_VERBOSE`          | Enable Verbosity in Logs                                               | `FALSE`              |          |

#### ClamAV Runtime Configuration

| Parameter                    | Description                                                       | Default                 | Advanced |
| ---------------------------- | ----------------------------------------------------------------- | ----------------------- | -------- |
| `ENABLE_CLAMD`               | Enable ClamD Daemon                                               | `TRUE`                  |          |
| `CLAMD_LOCAL_SOCKET`         | Clamd Socket Name                                                 | `/run/clamd/clamd.sock` |          |
| `CLAMD_TEMP_PATH`            | Camd Temp Location                                                | `/tmp/clamd/`           |          |
| `CONCURRENT_DATABASE_RELOAD` | Enable non-blocking (multi-threaded/concurrent) database reloads. | `TRUE`                  |          |
| `LISTEN_PORT`                | ClamD TCP Socket Listen port                                      | `3310`                  | x        |
| `LOG_FILE_CLAMD`             | ClamD Log File                                                    | `clamd.log`             |          |
| `SELFCHECK_INTERVAL`         | Database Self Check Interval in seconds                           | `600`                   | x        |

#### ClamAV Performance Configuration

| Parameter                     | Description                        | Default | Advanced |
| ----------------------------- | ---------------------------------- | ------- | -------- |
| `ENABLE_CACHE`                | Enable Cache                       | `TRUE`  |          |
| `CACHE_SIZE`                  | Amount of objets to store in cache | `65536` | x        |
| `TIMEOUT_READ`                | Read Timeout                       | `20`    | x        |
| `TIMEOUT_COMMAND_READ`        | Command Read Timeout               | `30`    | x        |
| `TIMEOUT_SEND_BUF`            | Send Buffer Timeout                | `500`   | x        |
| `TIMEOUT_IDLE`                | Idle Timeout                       | `60`    | x        |
| `MAX_QUEUE`                   | Maximum objects to be queued       | `100`   | x        |
| `MAX_THREADS`                 | Max Scanning Threads               | `10`    | x        |
| `MAX_CONNECTION_QUEUE_LENGTH` | Max Connection Queue Length        | `200`   | x        |
| `MAX_SCAN_TIME`               | Maximum File Scanning Time         | `0`     | x        |

#### Virus Definitions Configuration

| Parameter                      | Description                                                                          | Default         | Advanced |
| ------------------------------ | ------------------------------------------------------------------------------------ | --------------- | -------- |
| `ENABLE_DEFINITIONS_UPDATE`    | Enable Automatic Definitions Updating                                                | `TRUE`          |          |
| `DISABLE_CERT_CHECK`           | Disable PE Cert Checks                                                               | `TRUE`          |          |
| `LOG_FILE_FRESHCLAM`           | Freshclam Log File                                                                   | `freshclam.log` |          |
| `DEFINITIONS_UPDATE_FREQUENCY` | How often to check for new Definitions in minutes                                    | `1440`          | x        |
| `DEFINITIONS_UPDATE_BEGIN`     | What time to do the first dump. Defaults to immediate. Must be in one of two formats |                 |          |
|                                | Absolute HHMM, e.g. `2330` or `0415`                                                 |                 |          |
|                                | Relative +MM, i.e. how many minutes after starting the container,                    |                 |          |
|                                | e.g. `+0` (immediate), `+10` (in 10 minutes), or `+90` in an hour and a half         |                 |          |
| `FRESHCLAM_DATABASES`          | Comma seperated list of additional definitions eg                                    |                 |          |
|                                | `http://www.rfxn.com/downloads/rfxn.ndb,http://www.rfxn.com/downloads/rfxn.hdb`      |                 |          |

#### Virus Scanning Settings

| Parameter                          | Description                                      | Default          | Advanced |
| ---------------------------------- | ------------------------------------------------ | ---------------- | -------- |
| `ENABLE_ALGORITHMIC_DETECTION`     | Enable Algorithmic Detection                     | `TRUE`           |          |
| `ENABLE_BYTECODE`                  | Enable Bytecode Checks                           | `TRUE`           |          |
| `ENABLE_DETECT_PUA`                | Detect PUA                                       | `TRUE`           |          |
| `ENABLE_STRUCTURED_DATA_DETECTION` | Enable Data Loss Prevention Module               | `FALSE`          |          |
| `ENABLE_PHISHING_SCAN_URLS`        | Scan URLs for Phishing                           | `TRUE`           |          |
| `ENABLE_PHISHING_SIGNATURES`       | Scan for signatures related to Phishing          | `TRUE`           |          |
| `FOLLOW_DIRECTORY_SYMLINKS`        | Follow Symbolic Links of Directories             | `TRUE`           |          |
| `FOLLOW_FILE_SYMLINKS`             | Follow Symbolic Links of Files                   | `TRUE`           |          |
| `HEURISTIC_SCAN_PRECEDENCE`        | Allow precedence for Heuristic Scans             | `FALSE`          |          |
| `SCAN_ARCHIVE`                     | Scan Archives                                    | `TRUE`           |          |
| `SCAN_ELF`                         | Scan ELF files                                   | `TRUE`           |          |
| `SCAN_HTML`                        | Scan HTML Files                                  | `TRUE`           |          |
| `SCAN_MAIL`                        | Scan Mail Files                                  | `TRUE`           |          |
| `SCAN_ONENOTE`                     | Scan OneNote Files                               | `TRUE`           |          |
| `SCAN_XMLDOCS`                     | Scan XML Documents                               | `TRUE`           |          |
| `SCAN_HWP3`                        | Scan HWP3 Files                                  | `TRUE`           |          |
| `SCAN_IMAGES`                      | Scan Images                                      | `TRUE`           |          |
| `SCAN_IMAGES_FUZZY_HASH`           | Scan Images with Fuzzy Hashing                   | `TRUE`           |          |
| `SCAN_OLE2`                        | Scan OLE2 Files                                  | `TRUE`           |          |
| `SCAN_PDF`                         | Scan PDF Files                                   | `TRUE`           |          |
| `SCAN_PE`                          | Scan PE Files                                    | `TRUE`           |          |
| `SCAN_SWF`                         | Scan SWF Files                                   | `TRUE`           |          |
| `EXCLUDE_PUA`                      | Comma Seperated Values of PUA formats to exclude | `NetTool,PWTool` |          |
| `INCLUDE_PUA`                      | Comma Seperated Values of PUA formats to exclude | `(null)`         |          |

#### Scanning Limits

| Parameter                 | Description                      | Default  | Advanced |
| ------------------------- | -------------------------------- | -------- | -------- |
| `MAX_EMBEDDEDPE`          | Max filesize Embedded PE         | `40M`    | x        |
| `MAX_DIRECTORY_RECURSION` | How many directories to descend  | `15`     | x        |
| `MAX_FILE_SIZE`           | Max file to scan                 | `100M`   | x        |
| `MAX_FILES`               | Max files to scan                | `10000`  | x        |
| `MAX_HTMLNORMALIZE`       | Max HTML Normalize               | `40M`    | x        |
| `MAX_HTMLNOTAGS`          | Max HTML No Tags                 | `8M`     | x        |
| `MAX_ICONSPE`             | Max IconsPE                      | `100`    | x        |
| `MAX_PARTITIONS`          | Max Partitons to Scan            | `50`     | x        |
| `MAX_RECHWP3`             | Max Recursive HWP3               | `16`     | x        |
| `MAX_RECURSION`           | Max Folder Recursion in archives | `17`     | x        |
| `MAX_SCAN_SIZE`           | Max Scan Size                    | `400M`   | x        |
| `MAX_SCRIPTNORMALIZE`     | Max Script Normalize Scan        | `20M`    | x        |
| `MAX_ZIPTYPERCG`          | Max Zip type Recursive           | `1M`     | x        |
| `PCRE_MATCH_LIMIT`        | PCRE Match Limit                 | `100000` | x        |
| `PCRE_MAX_FILE_SIZE`      | PCRE Max File Size               | `100M`   | x        |
| `PCRE_RECMATCH_LIMIT`     | PCRE REcursive Max Limit         | `2000`   | x        |
| `STREAM_MAX_LENGTH`       | Max stream size to scan          | `25M`    | x        |

#### Action Settings

| Parameter           | Description                        | Default | Advanced |
| ------------------- | ---------------------------------- | ------- | -------- |
| `OLE2_BLOCK_MACROS` | Block Macros in OLE2 Files         | `FALSE` |          |
| `ALERT_SCRIPT`      | Script to execute when Virus found |         |          |

>> Script must be available on the file system and set as executible

#### Alerting Settings

| Parameter                      | Description                                                        | Default | Advanced |
| ------------------------------ | ------------------------------------------------------------------ | ------- | -------- |
| `ALERT_ENCRYPTED_ARCHIVE`      | Alert on encrypted archives (.zip, .7zip, .rar)                    | `FALSE` |          |
| `ALERT_ENCRYPTED_DOC`          | Alert on encrypted documents (.pdf)                                | `FALSE` |          |
| `ALERT_OLE2_MACROS`            | Alert on OLE2 files containing VBA macros                          | `FALSE` |          |
| `ALERT_EXCEEDS_MAX`            | Alert on files exceeding MAX_FILES, MAX_SCAN_SIZE or MAX_RECURSION | `FALSE` |          |
| `ALERT_BROKEN_EXECUTABLES`     | Alert on broken executibles                                        | `FALSE` |          |
| `ALERT_BROKEN_MEDIA`           | Alert on broken media                                              | `FALSE` |          |
| `ALERT_PHISHING_CLOAK`         | Alert on potential phishing cloaking of urls                       | `FALSE` |          |
| `ALERT_PHISHING_SSL`           | Alert on non matching SSL destinations                             | `FALSE` |          |
| `ALERT_PARTITION_INTERSECTION` | Alert on partition intersections in DMG files                      | `FALSE` |          |
| `ALERT_HEURISTIC`              | Alert on Heuristics findings                                       | `FALSE` |          |

## Users and Groups

| Type  | Name     | ID   |
| ----- | -------- | ---- |
| User  | `clamav` | 3310 |
| Group | `clamav` | 3310 |

### Networking

| Port   | Protocol | Description          |
| ------ | -------- | -------------------- |
| `3310` | tcp      | ClamD Listening Port |

* * *

## Maintenance

### Shell Access

For debugging and maintenance, `bash` and `sh` are available in the container.

### Manual Definition Updates

Manual Definition Updates can be performed by entering the container and typing `update-now`

## Support & Maintenance

- For community help, tips, and community discussions, visit the [Discussions board](/discussions).
- For personalized support or a support agreement, see [Nfrastack Support](https://nfrastack.com/).
- To report bugs, submit a [Bug Report](issues/new). Usage questions will be closed as not-a-bug.
- Feature requests are welcome, but not guaranteed. For prioritized development, consider a support agreement.
- Updates are best-effort, with priority given to active production use and support agreements.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
