FROM tiredofit/alpine:3.7
LABEL maintainer="Dave Conroy (dave at tiredofit dot ca)"

### Disable Features From Base Image
   ENV ENABLE_SMTP=FALSE

### Install Dependencies
   RUN set -x ; \
       apk update ; \
       apk add --no-cache \
               clamav \
               clamav-libunrar \
               ; \

### Cleanup
       rm -rf /var/cache/apk/* /usr/src/*

### Networking Configuration
   EXPOSE 3310

### Add Files
   ADD install /
