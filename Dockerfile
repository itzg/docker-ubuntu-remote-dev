ARG BASE_IMG=ubuntu:20.04
FROM ${BASE_IMG}

ADD https://packages.adoptium.net/artifactory/api/gpg/key/public /etc/apt/trusted.gpg.d/adoptium.asc
#ADD https://packages.adoptium.net/artifactory/api/gpg/key/public /etc/apt/keyrings/adoptium.asc

ARG JDK_RELEASE=17

ENV DEV_USER_HOME=/workspace
ENV DEV_USER_NAME=dev

RUN --mount=type=cache,target=/var/cache \
    --mount=type=cache,target=/var/log \
    --mount=source=build,target=/build \
    /build/install-packages.sh

RUN --mount=source=build,target=/build \
    /build/setup-user.sh

COPY configs/sshd/* /sshd/
COPY run /run

EXPOSE 2022

VOLUME ${DEV_USER_HOME}
VOLUME /sshd/configs.d
VOLUME /host_keys

ENTRYPOINT ["/run/run.sh"]