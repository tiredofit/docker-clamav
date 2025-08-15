# SPDX-FileCopyrightText: © 2025 Nfrastack <code@nfrastack.com>
#
# SPDX-License-Identifier: MIT

ARG BASE_IMAGE
ARG DISTRO
ARG DISTRO_VARIANT

FROM ${BASE_IMAGE}:${DISTRO}_${DISTRO_VARIANT}

LABEL \
        org.opencontainers.image.title="ClamAV" \
        org.opencontainers.image.description="Antivirus Scanner" \
        org.opencontainers.image.url="https://hub.docker.com/r/nfrastack/clamav" \
        org.opencontainers.image.documentation="https://github.com/nfrastack/container-clamav/blob/main/README.md" \
        org.opencontainers.image.source="https://github.com/nfrastack/container-clamav.git" \
        org.opencontainers.image.authors="Nfrastack <code@nfrastack.com>" \
        org.opencontainers.image.vendor="Nfrastack <https://www.nfrastack.com>" \
        org.opencontainers.image.licenses="MIT"

ARG     \
        CLAMAV_REPO_URL \
        CLAMAV_VERSION

COPY CHANGELOG.md /usr/src/container/CHANGELOG.md
COPY LICENSE /usr/src/container/LICENSE
COPY README.md /usr/src/container/README.md

ENV \
    CLAMAV_VERSION=${CLAMAV_VERSION:-"clamav-1.4.3"} \
    CLAMAV_REPO_URL=https://github.com/Cisco-Talos/clamav \
    CONTAINER_ENABLE_SCHEDULING=TRUE \
    IMAGE_NAME="nfrastack/clamav" \
    IMAGE_REPO_URL="https://github.com/nfrastack/container-clamav/"

RUN echo "" && \
    CLAMAV_BUILD_DEPS_ALPINE=" \
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
                                zlib-dev  \
                            " \
                        && \
    CLAMAV_RUN_DEPS_ALPINE=" \
                                check \
                                json-c \
                                libbz2 \
                                libmspack \
                                libmilter \
                                libxml2 \
                                openssl \
                                pcre2 \
                                zlib \
                            " \
                        && \
    \
    source /container/base/functions/container/build && \
    container_build_log && \
    create_user clamav 3310 clamav 3310 /var/lib/clamav && \
    package update && \
    package upgrade && \
    package install \
                        CLAMAV_BUILD_DEPS \
                        CLAMAV_RUN_DEPS \
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
          -D ENABLE_CLAMONACC=OFF \
          -D ENABLE_DOXYGEN=OFF \
          -D ENABLE_EXAMPLES=OFF \
          -D ENABLE_EXAMPLES_DEFAULT=OFF \
          -D ENABLE_EXTERNAL_MSPACK=ON \
          -D ENABLE_JSON_SHARED=ON \
          -D ENABLE_MAN_PAGES_DEFAULT=OFF \
          -D ENABLE_MILTER=ON \
          -D ENABLE_SYSTEMD=OFF \
          -D ENABLE_TESTS=OFF \
          -D HAVE_SYSTEM_LFS_FTS=0 \
          && \
    \
    make -j$(nproc) && \
    make install && \
    \
    package remove \
                    CLAMAV_BUILD_DEPS \
                    && \
    package cleanup

EXPOSE 3310

COPY rootfs /
