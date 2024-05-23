ARG DISTRO="alpine"
ARG DISTRO_VARIANT="3.20"

FROM docker.io/tiredofit/${DISTRO}:${DISTRO_VARIANT}
LABEL maintainer="Dave Conroy (github.com/tiredofit)"

ARG CLAMAV_VERSION

ENV CLAMAV_VERSION=${CLAMAV_VERSION:-"clamav-1.3.1"} \
    CLAMAV_REPO_URL=https://github.com/Cisco-Talos/clamav \
    CONTAINER_ENABLE_MESSAGING=FALSE \
    IMAGE_NAME="tiredofit/clamav" \
    IMAGE_REPO_URL="https://github.com/tiredofit/docker-clamav/"

### Install Dependencies
RUN source /assets/functions/00-container && \
    set -x && \
    addgroup -g 3310 clamav && \
    adduser -S -D -G clamav -u 3310 -h /var/lib/clamav/ clamav && \
    package update && \
    package upgrade && \
    package install .clamav-build-deps \
                build-base \
                bzip2-dev \
                cargo \
                check-dev \
                cmake \
                curl-dev \
                git \
                json-c-dev \
                libmspack-dev \
                libmilter-dev \
                openssl-dev \
                libxml2-dev \
                linux-headers \
                ncurses-dev \
                pcre2-dev \
                python3 \
                samurai \
                zlib-dev \
                && \
    \
    package install .clamav-run-deps \
                bzip2 \
                check \
                json-c \
                libmspack \
                libmilter \
                libxml2 \
                openssl \
                pcre2 \
                zlib \
                && \
    \
    clone_git_repo ${CLAMAV_REPO_URL} ${CLAMAV_VERSION} && \
    cmake \
          -G "Unix Makefiles" \
          -D CMAKE_BUILD_TYPE=MinSizeRel \
          -D CMAKE_BUILD_TYPE=None \
          -D CMAKE_INSTALL_PREFIX=/usr \
          -D CMAKE_INSTALL_LIBDIR=/usr/lib \
          -D APP_CONFIG_DIRECTORY=/etc/clamav \
          -D DATABASE_DIRECTORY=/var/lib/clamav \
          -D ENABLE_TESTS=OFF \
          -D ENABLE_CLAMONACC=OFF \
          -D ENABLE_MILTER=ON \
          -D ENABLE_EXTERNAL_MSPACK=ON \
          -D ENABLE_EXAMPLES=OFF \
          -D ENABLE_EXAMPLES_DEFAULT=OFF \
          -D HAVE_SYSTEM_LFS_FTS=0 \
          -D ENABLE_JSON_SHARED=ON \
          && \
    make -j$(nproc) && \
    make install && \
    \
    package remove .clamav-build-deps && \
    package cleanup && \
    rm -rf /root/.cargo \
           /root/.gitconfig \
           /usr/src/*

EXPOSE 3310

COPY install /
