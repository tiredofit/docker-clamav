# hub.docker.com/r/tiredofit/clamav
[![Build Status](https://img.shields.io/docker/build/tiredofit/clamav.svg)](https://hub.docker.com/r/tiredofit/clamav)
[![Docker Pulls](https://img.shields.io/docker/pulls/tiredofit/clamav.svg)](https://hub.docker.com/r/tiredofit/clamav)
[![Docker Stars](https://img.shields.io/docker/stars/tiredofit/clamav.svg)](https://hub.docker.com/r/tiredofit/clamav)
[![Docker Layers](https://images.microbadger.com/badges/image/tiredofit/clamav.svg)](https://microbadger.com/images/tiredofit/clamav)

## Introduction

Dockerfile to build an [Clam Antivirus](https://www.clamav.net) container image to scan files or mail messages.

- Auto Configuration Support
- Sane Defaults
- Automatic Downlad and update of Virus Definitions
- Log rotation

* This Container uses a [customized Alpine base](https://hub.docker.com/r/tiredofit/alpine) which includes [s6 overlay](https://github.com/just-containers/s6-overlay) enabled for PID 1 Init capabilities, [zabbix-agent](https://zabbix.org) for individual container monitoring, Cron also installed along with other tools (bash,curl, less, logrotate, nano, vim) for easier management.

[Changelog](CHANGELOG.md)

## Authors

- [Dave Conroy](https://github.com/tiredofit/)

## Table of Contents

- [Introduction](#introduction)
- [Authors](#authors)
- [Table of Contents](#table-of-contents)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
  - [Quick Start](#quick-start)
- [Configuration](#configuration)
  - [Data-Volumes](#data-volumes)
  - [Environment Variables](#environment-variables)
  - [Networking](#networking)
- [Maintenance](#maintenance)
  - [Shell Access](#shell-access)
- [References](#references)

## Prerequisites

This container doesn't do much on it's own unless you use an additional service or communicator to talk to it! You can scan files if you'd like by binding a volume inside the container but that is not the intent of this image.


## Installation

Automated builds of the image are available on [Docker Hub](https://hub.docker.com/r/tiredofit/clamav) and is the recommended method of installation.


```bash
docker pull tiredofit/clamav:(imagetag)
```

The following image tags are available:
* `latest` - Most recent release of ClamAV w/Alpine Linux Edge

### Quick Start

* The quickest way to get started is using [docker-compose](https://docs.docker.com/compose/). See the examples folder for a working [docker-compose.yml](examples/docker-compose.yml) that can be modified for development or production use.

* Set various [environment variables](#environment-variables) to understand the capabilities of this image.
* Map [persistent storage](#data-volumes) for access to configuration and data files for backup.


## Configuration

### Data-Volumes

The container will look for definition files upon startup in `/data` and if not found, download them. 6 times a day it will also check for updated definitions.

The following directories are used for configuration and can be mapped for persistent storage.

| Directory           | Description         |
| ------------------- | ------------------- |
| `/data/definitions` | Virus Definitions   |
| `/data/config`      | Configuration Files |
| `/logs`             | Log Files           |

### Environment Variables

Along with the Environment Variables from the [Base image](https://hub.docker.com/r/tiredofit/alpine), below is the complete list of available options that can be used to customize your installation.

*Core Configuration*

| Parameter               | Description                                                            | Default                         |
| ----------------------- | ---------------------------------------------------------------------- | ------------------------------- |
| `SETUP_TYPE`            | Auto Configure Configuration each startup - Set to `MANUAL` to disable | `AUTO`                          |
| `CLAMD_CONFIG_FILE`     | Clamd Configuration file                                               | `clamd.conf`                    |
| `CLAMD_LOCAL_SOCKET`    | Clamd Socket Name                                                      | `/run/clamd/clamd.sock`         |
| `CLAMD_TEMP_LOCATION`   | CLamd Temp Location                                                    | `/tmp/clamd/`                   |
| `DATA_LOCATION`         | Base Folder for Data Files                                             | `/data/`                        |
| `CONFIG_LOCATION`       | Folder for Config Files                                                | `${DATA_LOCATION}/config/`      |
| `DEFINITIONS_LOCATION`  | Folder for Virus Definitions                                           | `${DATA_LOCATION`/definitions/` |
| `ENABLE_CLAMD`          | Enable ClamD Daemon                                                    | `TRUE`                          |
| `ENABLE_LOG_CLAMD`      | Enable Logging for Clamd                                               | `TRUE`                          |
| `ENABLE_LOG_FRESHCLAM`  | Enable Logging for Definitions Updaer                                  | `TRUE`                          |
| `FRESHCLAM_CONFIG_FILE` | Freshclam Definitions Updater configuration file                       | `freshclam.conf`                |
| `LISTEN_PORT`           | ClamD TCP Socket Listen port                                           | `3310`                          |
| `LOG_CLAMD_FILE`        | ClamD Log File                                                         | `clamd.log`                     |
| `LOG_FRESHCLAM_FILE`    | Freshclam Log File                                                     | `freshclam.log`                 |
| `LOG_LOCATION`          | Logfile locations                                                      | `/logs/`                        |
| `LOG_VERBOSE`           | Enable Verbosity in Logs                                               | `FALSE`                         |


*Virus Definitions Configuration*

| Parameter                      | Description                                                                                                                                    | Default |
| ------------------------------ | ---------------------------------------------------------------------------------------------------------------------------------------------- | ------- |
| `ENABLE_DEFINITIONS_UPDATE`    | Enable Automatic Definitions Updating                                                                                                          | `TRUE`  |
| `DEFINITIONS_UPDATE_FREQUENCY` | How often to check for new Definitions in minutes                                                                                              | `60`    |
| `DEFINITIONS_UPDATE_BEGIN`     | What time to do the first dump. Defaults to immediate. Must be in one of two formats                                                           |
|                                | Absolute HHMM, e.g. `2330` or `0415`                                                                                                           |
|                                | Relative +MM, i.e. how many minutes after starting the container, e.g. `+0` (immediate), `+10` (in 10 minutes), or `+90` in an hour and a half |

*Virus Scanning Settings*

| Parameter                      | Description                                      | Default          |
| ------------------------------ | ------------------------------------------------ | ---------------- |
| `DISABLE_CERT_CHECK`           | Disable PE Cert Checks                           | `TRUE`           |
| `ENABLE_ALGORITHMIC_DETECTION` | Enable Algorithmic Detection                     | `TRUE`           |
| `ENABLE_BYTECODE`              | Enable Bytecode Checks                           | `TRUE`           |
| `ENABLE_DETECT_PUA`            | Detect PUA                                       | `TRUE`           |
| `ENABLE_PHISHING_SCAN_URLS`    | Scan URLs for Phishing                           | `TRUE`           |
| `ENABLE_PHISHING_SIGNATURES`   | Scan for signatures related to Phishing          | `TRUE`           |
| `ENABLE_SCAN_ARCHIVE`          | Scan Archives                                    | `TRUE`           |
| `ENABLE_SCAN_ELF`              | Scan ELF files                                   | `TRUE`           |
| `ENABLE_SCAN_HTML`             | Scan HTML Files                                  | `TRUE`           |
| `ENABLE_SCAN_MAIL`             | Scan Mail Files                                  | `TRUE`           |
| `ENABLE_SCAN_OLE2`             | Scan OLE2 Files                                  | `TRUE`           |
| `ENABLE_SCAN_PDF`              | Scan PDF Files                                   | `TRUE`           |
| `ENABLE_SCAN_PE`               | Scan PE Files                                    | `TRUE`           |
| `ENABLE_SCAN_SWF`              | Scan SWF Files                                   | `TRUE`           |
| `EXCLUDE_PUA`                  | Comma Seperated Values of PUA formats to exclude | `NetTool,PWTool` |
| `INCLUDE_PUA`                  | Comma Seperated Values of PUA formats to exclude | `(null)`         |

*Scanning Limits*

| Parameter             | Description               | Default |
| --------------------- | ------------------------- | ------- |
| `MAX_EMBEDDEDPE`      | Max filesize Embedded PE  | `10M`   |
| `MAX_FILE_SIZE`       | Max file to scan          | `25M`   |
| `MAX_FILES`           | Max files to scan         | `10000` |
| `MAX_HTMLNORMALIZE`   | Max HTML Normalize        | `10M`   |
| `MAX_HTMLNOTAGS`      | Max HTML No Tags          | `2M`    |
| `MAX_ICONSPE`         | Max IconsPE               | `100`   |
| `MAX_PARTITIONS`      | Max Partitons to Scan     | `50`    |
| `MAX_RECHWP3`         | Max Recursive HWP3        | `16`    |
| `MAX_RECURSION`       | Max Folder Recursion      | `16`    |
| `MAX_SCAN_SIZE`       | Max Scan Size             | `100M`  |
| `MAX_SCRIPTNORMALIZE` | Max Script Normalize Scan | `5M`    |
| `MAX_THREADS`         | Max Scanning Threads      | `10`    |
| `MAX_ZIPTYPERCG`      | Max Zip type Recursive    | `1M`    |
| `PCRE_MATCH_LIMIT`    | PCRE Match Limit          | `10000` |
| `PCRE_MAX_FILE_SIZE`  | PCRE Max File Size        | `25M`   |
| `PCRE_RECMATCH_LIMIT` | PCRE REcursive Max Limit  | `2000`  |

### Networking

| Port   | Description          |
| ------ | -------------------- |
| `3310` | ClamD Listening Port |

## Maintenance

### Shell Access

For debugging and maintenance purposes you may want access the containers shell.

```bash
docker exec -it (whatever your container name is e.g. clamav) bash
```

## References

* https://www.clamav.net
