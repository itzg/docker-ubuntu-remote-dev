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

COPY configs/sshd/* /etc/ssh/sshd_config.d/
COPY run /run

#USER 1000

VOLUME ${DEV_USER_HOME}
#WORKDIR /workspace

EXPOSE 2022

ENTRYPOINT ["/run/run.sh"]