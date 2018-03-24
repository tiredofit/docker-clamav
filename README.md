# hub.docker.com/tiredofit/clamav


[![Build Status](https://img.shields.io/docker/build/tiredofit/clamav.svg)](https://hub.docker.com/r/tiredofit/clamav)
[![Docker Pulls](https://img.shields.io/docker/pulls/tiredofit/clamav.svg)](https://hub.docker.com/r/tiredofit/clamav)
[![Docker Stars](https://img.shields.io/docker/stars/tiredofit/clamav.svg)](https://hub.docker.com/r/tiredofit/clamav)
[![Docker Layers](https://images.microbadger.com/badges/image/tiredofit/clamav.svg)](https://microbadger.com/images/tiredofit/clamav)


# Introduction

Dockerfile to build an [Clam Antivirus](https://www.clamav.net) container image to scan files or most commonly, mail messages.

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

Automated builds of the image are available on [Registry](https://hub.docker.com/tiredofit/clamav) and is the recommended method of installation.


```bash
docker pull hub.docker.com/tiredofit/clamav:(imagetag)
```

The following image tags are available:
* `latest` - Most recent release of ClamAV w/Alpine Linux 3.6

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
| `/data` | Database Directory |
| `/var/log/clamav` | Log Files |

### Environment Variables

Along with the Environment Variables from the [Base image](https://hub.docker.com/r/tiredofit/alpine), below is the complete list of available options that can be used to customize your installation.

| Parameter | Description |
|-----------|-------------|
| `MAX_SCAN_SIZE` | Amount of data scanned for each file - Default `150M` |
| `MAX_FILE_SIZE` | Don't scan files larger than this size - Default `30M` |
| `MAX_RECURSION` | How many nested archives to scan - Default `10` |
| `MAX_FILES` | Number of files to scan withn archive - Default `15000` |
| `MAX_EMBEDDEDPE` | Maximum file size for embedded PE - Default `10M` |
| `MAX_HTMLNORMALIZE` | Maximum size of HTML to normalize - Default `10M` |
| `MAX_HTMLNOTAGS` | Maximum size of Normlized HTML File to scan- Default `2M` |
| `MAX_SCRIPTNORMALIZE` | Maximum size of a Script to normalize - Default `5M` |
| `MAX_ZIPTYPERCG` | Maximum size of ZIP to reanalyze type recognition - Default `1M` |
| `MAX_PARTITIONS` | How many partitions per Raw disk to scan - Default `128` |
| `MAX_ICONSPE` | How many Icons in PE to scan - Default `200` |
| `PCRE_MATCHLIMIT` | Maximum PCRE Match Calls - Default `10000` |
| `PCRE_RECMATCHLIMIT` | Maximum Recursive Match Calls to PCRE - Default `10000` |

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
