## 2.2.3 2021-10-25 <dave at tiredofit dot ca>

   ### Added
      - Add fluent-bit log parsing regular expressions


## 2.2.2 2021-09-13 <dave at tiredofit dot ca>

   ### Changed
      - Fix for 2.2.0 still not writing correct log files


## 2.2.1 2021-09-12 <morgenroth@github>

   ## Fixed
      - Fix for 2.2.0 release where defaults weren't appropriately set


## 2.2.0 2021-09-04 <dave at tiredofit dot ca>

   ### Changed
      - Change LOG environment variables (LOG_LOCATION -> LOG_PATH) (LOG_*_FILE -> LOG_FILE_*)
      - Change the way logrotation is configured for regex parsing


## 2.1.2 2021-06-28 <scopaala@github>

   ### Changed
      - Fix for 2.1.0 - Included PUA had a spelling mistake

## 2.1.1 2021-06-28 <dave at tiredofit dot ca>

   ### Changed
      - Fix for 2.1.0 - Excluded PUA was not creating a new line properly


## 2.1.0 2021-06-25 <dave at tiredofit dot ca>

   ### Changed
      - Fix for Included and Excluded PUA


## 2.0.6 2020-09-11 <marxjohnson@gitub>

   ### Added
      - Add STREAM_MAX_SIZE environment variable for proper size limiting of scanning

## 2.0.5 2020-07-31 <dave at tiredofit dot ca>

   ### Added
      - Add alias for clamscan to pull from $DEFINITIONS_LOCATION instead of /var/lib/clamav


## 2.0.4 2020-07-06 <dave at tiredofit dot ca>

   ### Added
      - Added symbolic link from /var/lib/clamav to ${DEFINITIONS_LOCATION} to quiet down any errors running manual scans with clamscan

   ### Changed
      - Cleaned up code as per shellcheck warnings


## 2.0.3 2020-06-20 <dave at tiredofit dot ca>

   ### Changed
      - Fix for logrotate not sending SIGHUP properly and removed extra logroate config


## 2.0.2 2020-06-15 <dave at tiredofit dot ca>

   ### Changed
      - Bugfix for 2.0.1 Release


## 2.0.1 2020-06-08 <dave at tiredofit dot ca>

   ### Added
      - Update to support changes in tiredofit/alpine base


## 2.0.0 2020-05-17 <dave at tiredofit dot ca>

   ### Added
      - Rewrote entire image
      - Alpine Edge
      - All parameters configurable with auto config generation
      - Reworked Definitions Updating Routings to be ultra configurable


## 1.6.2 2020-04-01 <cauger@github>

   ### Changed
      - Fixed cron expression to not run definitions update every minute

## 1.6.1 2020-01-02 <dave at tiredofit dot ca>

   ### Changed
      - Additional changes to support new tiredofit/alpine base image


## 1.6.0 2019-12-30 <dave at tiredofit dot ca>

   ### Added
      - Update to support new tiredofit/alpine base image


## 1.5.1 2019-12-20 <dave at tiredofit dot ca>

   ### Added
      - Alpine 3.11 Base


## 1.5 2019-06-19 Dave Conroy <dave at tiredofit.ca>

* Base bumpt to Alpine 3.10

## 1.4 2019-02-08 Dave Conroy <dave at tiredofit.ca>

* Base Bump to Alpine 3.9

## 1.3 2017-12-01 Dave Conroy <dave at tiredofit.ca>

* Base bump to Alpine 3.7

## 1.2 2017-09-17 Dave Conroy <dave at tiredofit dot ca>

* Debug Mode Tweak

## 1.1 2017-09-12 Dave Conroy <dave at tiredofit dot ca>

* Permissions Fix

## 1.0 2017-09-12 Dave Conroy <dave at tiredofit dot ca>

* Initial Public Release
* Alpine 3.6
* Freshclam runs 6 times a day

## 0.1 2017-09-12 Dave Conroy <dave at tiredofit dot ca>

* Initial _not working_ release

