FROM docker.io/tiredofit/alpine:edge
LABEL maintainer="Dave Conroy (github.com/tiredofit)"

### Disable Features From Base Image
ENV CONTAINER_ENABLE_MESSAGING=FALSE \
    IMAGE_NAME="tiredofit/clamav" \
    IMAGE_REPO_URL="https://github.com/tiredofit/docker-clamav/"

### Install Dependencies
RUN set -x && \
    apk update && \
    apk upgrade && \
    apk add -t .clamv-run-deps \
              clamav \
              clamav-libunrar \
              && \
    \
### Cleanup
    rm -rf /etc/logrotate.d/* && \
    rm -rf /var/cache/apk/*

### Networking Configuration
EXPOSE 3310

### Add Files
ADD install /
