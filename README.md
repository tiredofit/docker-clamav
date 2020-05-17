# hub.docker.com/r/tiredofit/clamav
[![Build Status](https://img.shields.io/docker/build/tiredofit/clamav.svg)](https://hub.docker.com/r/tiredofit/clamav)
[![Docker Pulls](https://img.shields.io/docker/pulls/tiredofit/clamav.svg)](https://hub.docker.com/r/tiredofit/clamav)
[![Docker Stars](https://img.shields.io/docker/stars/tiredofit/clamav.svg)](https://hub.docker.com/r/tiredofit/clamav)
[![Docker Layers](https://images.microbadger.com/badges/image/tiredofit/clamav.svg)](https://microbadger.com/images/tiredofit/clamav)

# Introduction

Dockerfile to build an [Clam Antivirus](https://www.clamav.net) container image to scan files or mail messages.

- Auto Configuration Support
- Sane Defaults
- Automatic Downlad and update of Virus Definitions
- Log rotation

* This Container uses a [customized Alpine base](https://hub.docker.com/r/tiredofit/alpine) which includes [s6 overlay](https://github.com/just-containers/s6-overlay) enabled for PID 1 Init capabilities, [zabbix-agent](https://zabbix.org) for individual container monitoring, Cron also installed along with other tools (bash,curl, less, logrotate, nano, vim) for easier management. 

[Changelog](CHANGELOG.md)

# Authors

- [Dave Conroy](https://github.com/tiredofit/)

# Table of Contents

- [Introduction](#introduction)
    - [Changelog](CHANGELOG.md)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Quick Start](#quick-start)
- [Configuration](#configuration)
    - [Data Volumes](#data-volumes)
    - [Environment Variables](#environmentvariables)   
- [Maintenance](#maintenance)
    - [Shell Access](#shell-access)
   - [References](#references)

# Prerequisites

This container doesn't do much on it's own unless you use an additional service or communicator to talk to it!


# Installation

Automated builds of the image are available on [Registry](https://hub.docker.com/r/tiredofit/clamav) and is the recommended method of installation.


```bash
docker pull hub.docker.com/tiredofit/clamav:(imagetag)
```

The following image tags are available:
* `latest` - Most recent release of ClamAV w/Alpine Linux Edge

# Quick Start

* The quickest way to get started is using [docker-compose](https://docs.docker.com/compose/). See the examples folder for a working [docker-compose.yml](examples/docker-compose.yml) that can be modified for development or production use.

* Set various [environment variables](#environment-variables) to understand the capabilities of this image.
* Map [persistent storage](#data-volumes) for access to configuration and data files for backup.


# Configuration

### Data-Volumes

The container will look for definition files upon startup in `/data` and if not found, download them. 6 times a day it will also check for updated definitions.

The following directories are used for configuration and can be mapped for persistent storage.

| Directory | Description |
|-----------|-------------|
| `/data/definitions` | Virus Definitions |
| `/data/config` | Configuration Files |
| `/logs` | Log Files |

### Environment Variables

Along with the Environment Variables from the [Base image](https://hub.docker.com/r/tiredofit/alpine), below is the complete list of available options that can be used to customize your installation.

*Core Configuration*

| Parameter | Description |
|-----------|-------------|
| `SETUP_TYPE` | Auto Configure Configuration each startup - Set to `MANUAL` to disable - Default: `AUTO` |
| `CLAMD_CONFIG_FILE` | Clamd Configuration file - Default: `clamd.conf` |
| `CLAMD_LOCAL_SOCKET` | Clamd Socket Name - Default: `/run/clamd/clamd.sock` |
| `CLAMD_TEMP_LOCATION` | CLamd Temp Location - Default: `/tmp/clamd/` |
| `DATA_LOCATION` | Base Folder for Data Files - Default: `/data/` |
| `CONFIG_LOCATION` | Folder for Config Files - Default: `${DATA_LOCATION}/config/` |
| `DEFINITIONS_LOCATION` | Folder for Virus Definitions - Default: `${DATA_LOCATION`/definitions/` |
| `ENABLE_CLAMD` | Enable ClamD Daemon - Default: `TRUE` |
| `ENABLE_LOG_CLAMD` | Enable Logging for Clamd - Default: `TRUE` |
| `ENABLE_LOG_FRESHCLAM` | Enable Logging for Definitions Updaer - Default: `TRUE` |
| `FRESHCLAM_CONFIG_FILE` | Freshclam Definitions Updater configuration file - Default: `freshclam.conf` |
| `LISTEN_PORT` | ClamD TCP Socket Listen port - Default: `3310` |
| `LOG_CLAMD_FILE` | ClamD Log File - Default: `clamd.log` |
| `LOG_FRESHCLAM_FILE` | Freshclam Log File - Default: `freshclam.log` |
| `LOG_LOCATION` | Logfile locations - Default: `/logs/` |
| `LOG_VERBOSE` | Enable Verbosity in Logs - Default: `FALSE` |


*Virus Definitions Configuration*

| Parameter | Description |
|-----------|-------------|
| `ENABLE_DEFINITIONS_UPDATE` | Enable Automatic Definitions Updating - Default: `TRUE` |
| `DEFINITIONS_UPDATE_FREQUENCY` | How often to check for new Definitions in minutes - Default: `60` |
| `DEFINITIONS_UPDATE_BEGIN` | What time to do the first dump. Defaults to immediate. Must be in one of two formats |
| | Absolute HHMM, e.g. `2330` or `0415` |
| | Relative +MM, i.e. how many minutes after starting the container, e.g. `+0` (immediate), `+10` (in 10 minutes), or `+90` in an hour and a half |

*Virus Scanning Settings*

| Parameter | Description |
|-----------|-------------|
| `DISABLE_CERT_CHECK` | Disable PE Cert Checks - Default: `TRUE` |
| `ENABLE_ALGORITHMIC_DETECTION` | Enable Algorithmic Detection - Default: `TRUE` |
| `ENABLE_BYTECODE` | Enable Bytecode Checks - Default: `TRUE` |
| `ENABLE_DETECT_PUA` | Detect PUA - Default: `TRUE` |
| `ENABLE_PHISHING_SCAN_URLS` | Scan URLs for Phishing - Default: `TRUE` |
| `ENABLE_PHISHING_SIGNATURES` | Scan for signatures related to Phishing - Default: `TRUE` |
| `ENABLE_SCAN_ARCHIVE` | Scan Archives - Default: `TRUE` |
| `ENABLE_SCAN_ELF` | Scan ELF files - Default: `TRUE` |
| `ENABLE_SCAN_HTML` | Scan HTML Files - Default: `TRUE` |
| `ENABLE_SCAN_MAIL` | Scan Mail Files - Default: `TRUE` |
| `ENABLE_SCAN_OLE2` | Scan OLE2 Files - Default: `TRUE` |
| `ENABLE_SCAN_PDF` | Scan PDF Files - Default: `TRUE` |
| `ENABLE_SCAN_PE` | Scan PE Files - Default: `TRUE` |
| `ENABLE_SCAN_SWF` | Scan SWF Files - Default: `TRUE` |
| `EXCLUDE_PUA` | Comma Seperated Values of PUA formats to exclude - Default: `NetTool,PWTool` |
| `INCLUDE_PUA` | Comma Seperated Values of PUA formats to exclude - Default: `(null)` |

*Scanning Limits*

| Parameter | Description |
|-----------|-------------|
| `MAX_EMBEDDEDPE` | Max filesize Embedded PE - Default: `10M` |
| `MAX_FILE_SIZE` | Max file to scan - Default: `25M` |
| `MAX_FILES` | Max files to scan - Default: `10000` |
| `MAX_HTMLNORMALIZE` | Max HTML Normalize - Default: `10M` |
| `MAX_HTMLNOTAGS` | Max HTML No Tags - Default: `2M` |
| `MAX_ICONSPE` | Max IconsPE - Default: `100` |
| `MAX_PARTITIONS` | Max Partitons to Scan - Default: `50` |
| `MAX_RECHWP3` | Max Recursive HWP3 - Default: `16` |
| `MAX_RECURSION` | Max Folder Recursion - Default: `16` |
| `MAX_SCAN_SIZE` | Max Scan Size - Default: `100M` |
| `MAX_SCRIPTNORMALIZE` | Max Script Normalize Scan - Default: `5M` |
| `MAX_THREADS` | Max Scanning Threads - Default: `10` |
| `MAX_ZIPTYPERCG` | Max Zip type Recursive - Default: `1M` |
| `PCRE_MATCH_LIMIT` | PCRE Match Limit - Default: `10000` |
| `PCRE_MAX_FILE_SIZE` | PCRE Max File Size - Default: `25M` |
| `PCRE_RECMATCH_LIMIT` | PCRE REcursive Max Limit - Default: `2000` |

### Networking

| Port | Description |
|-----------|-------------|
| `3310`    | ClamD Listening Port |

# Maintenance

#### Shell Access

For debugging and maintenance purposes you may want access the containers shell. 

```bash
docker exec -it (whatever your container name is e.g. clamav) bash
```

# References

* https://www.clamav.net
