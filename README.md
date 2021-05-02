# github.com/tiredofit/docker-clamav

[![GitHub release](https://img.shields.io/github/v/tag/tiredofit/docker-clamav?style=flat-square)](https://github.com/tiredofit/docker-clamav/releases/latest)
[![Build Status](https://img.shields.io/github/workflow/status/tiredofit/docker-clamav/build?style=flat-square)](https://github.com/tiredofit/docker-clamav/actions?query=workflow%3Abuild)
[![Docker Stars](https://img.shields.io/docker/stars/tiredofit/clamav.svg?style=flat-square&logo=docker)](https://hub.docker.com/r/tiredofit/clamav/)
[![Docker Pulls](https://img.shields.io/docker/pulls/tiredofit/clamav.svg?style=flat-square&logo=docker)](https://hub.docker.com/r/tiredofit/clamav/)
[![Become a sponsor](https://img.shields.io/badge/sponsor-tiredofit-181717.svg?logo=github&style=flat-square)](https://github.com/sponsors/tiredofit)
[![Paypal Donate](https://img.shields.io/badge/donate-paypal-00457c.svg?logo=paypal&style=flat-square)](https://www.paypal.me/tiredofit)

* * *
## About

Dockerfile to build an [Clam Antivirus](https://www.clamav.net) to scan files or mail messages.

- Auto Configuration Support
- Sane Defaults
- Automatic Downlad and update of Virus Definitions
- Log rotation

## Maintainer

- [Dave Conroy](https://github.com/tiredofit/)

## Table of Contents

- [About](#about)
- [Maintainer](#maintainer)
- [Table of Contents](#table-of-contents)
- [Prerequisites and Assumptions](#prerequisites-and-assumptions)
- [Installation](#installation)
  - [Build from Source](#build-from-source)
  - [Prebuilt Images](#prebuilt-images)
- [Configuration](#configuration)
  - [Quick Start](#quick-start)
  - [Persistent Storage](#persistent-storage)
  - [Environment Variables](#environment-variables)
    - [Base Images used](#base-images-used)
    - [Core Configuration](#core-configuration)
    - [Virus Definitions Configuration](#virus-definitions-configuration)
    - [Virus Scanning Settings](#virus-scanning-settings)
    - [Scanning Limits](#scanning-limits)
  - [Networking](#networking)
- [Maintenance](#maintenance)
  - [Shell Access](#shell-access)
- [Support](#support)
  - [Usage](#usage)
  - [Bugfixes](#bugfixes)
  - [Feature Requests](#feature-requests)
  - [Updates](#updates)
- [License](#license)

## Prerequisites and Assumptions

- This container doesn't do much on it's own unless you use an additional service or communicator to talk to it! You can scan files if you'd like by binding a volume inside the container but that is not the intent of this image.


## Installation

### Build from Source
Clone this repository and build the image with `docker build <arguments> (imagename) .`

### Prebuilt Images
Builds of the image are available on [Docker Hub](https://hub.docker.com/r/tiredofit/clamav) and is the recommended method of installation.

```bash
docker pull tiredofit/clamav:(imagetag)
```

The following image tags are available along with their taged release based on what's written in the [Changelog](CHANGELOG.md):

| Container OS | Tag       |
| ------------ | --------- |
| Alpine       | `:latest` |


## Configuration

### Quick Start

* The quickest way to get started is using [docker-compose](https://docs.docker.com/compose/). See the examples folder for a working [docker-compose.yml](examples/docker-compose.yml) that can be modified for development or production use.

* Set various [environment variables](#environment-variables) to understand the capabilities of this image.
* Map [persistent storage](#data-volumes) for access to configuration and data files for backup.

### Persistent Storage

The container will look for definition files upon startup in `/data` and if not found, download them. 6 times a day it will also check for updated definitions.

The following directories are used for configuration and can be mapped for persistent storage.

| Directory           | Description         |
| ------------------- | ------------------- |
| `/data/definitions` | Virus Definitions   |
| `/data/config`      | Configuration Files |
| `/logs`             | Log Files           |

### Environment Variables

#### Base Images used

This image relies on an [Alpine Linux](https://hub.docker.com/r/tiredofit/alpine) or [Debian Linux](https://hub.docker.com/r/tiredofit/debian) base image that relies on an [init system](https://github.com/just-containers/s6-overlay) for added capabilities. Outgoing SMTP capabilities are handlded via `msmtp`. Individual container performance monitoring is performed by [zabbix-agent](https://zabbix.org). Additional tools include: `bash`,`curl`,`less`,`logrotate`, `nano`,`vim`.

Be sure to view the following repositories to understand all the customizable options:

| Image                                                  | Description                            |
| ------------------------------------------------------ | -------------------------------------- |
| [OS Base](https://github.com/tiredofit/docker-alpine/) | Customized Image based on Alpine Linux |


#### Core Configuration

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


#### Virus Definitions Configuration

| Parameter                      | Description                                                                                                                                    | Default |
| ------------------------------ | ---------------------------------------------------------------------------------------------------------------------------------------------- | ------- |
| `ENABLE_DEFINITIONS_UPDATE`    | Enable Automatic Definitions Updating                                                                                                          | `TRUE`  |
| `DEFINITIONS_UPDATE_FREQUENCY` | How often to check for new Definitions in minutes                                                                                              | `60`    |
| `DEFINITIONS_UPDATE_BEGIN`     | What time to do the first dump. Defaults to immediate. Must be in one of two formats                                                           |
|                                | Absolute HHMM, e.g. `2330` or `0415`                                                                                                           |
|                                | Relative +MM, i.e. how many minutes after starting the container, e.g. `+0` (immediate), `+10` (in 10 minutes), or `+90` in an hour and a half |

#### Virus Scanning Settings

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

#### Scanning Limits

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
| `STREAM_MAX_LENGTH`   | Max stream size to scan   | `25M`   |

### Networking

| Port   | Description          |
| ------ | -------------------- |
| `3310` | ClamD Listening Port |

* * *
## Maintenance

### Shell Access

For debugging and maintenance purposes you may want access the containers shell.

``bash
docker exec -it (whatever your container name is) bash
``
## Support

These images were built to serve a specific need in a production environment and gradually have had more functionality added based on requests from the community.
### Usage
- The [Discussions board](../../discussions) is a great place for working with the community on tips and tricks of using this image.
- Consider [sponsoring me](https://github.com/sponsors/tiredofit) personalized support.
### Bugfixes
- Please, submit a [Bug Report](issues/new) if something isn't working as expected. I'll do my best to issue a fix in short order.

### Feature Requests
- Feel free to submit a feature request, however there is no guarantee that it will be added, or at what timeline.
- Consider [sponsoring me](https://github.com/sponsors/tiredofit) regarding development of features.

### Updates
- Best effort to track upstream changes, More priority if I am actively using the image in a production environment.
- Consider [sponsoring me](https://github.com/sponsors/tiredofit) for up to date releases.

## License
MIT. See [LICENSE](LICENSE) for more details.## References

* https://www.clamav.net
