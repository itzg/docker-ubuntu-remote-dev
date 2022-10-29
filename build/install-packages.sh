#!/usr/bin/env sh
set -eu

apt-get update

DEBIAN_FRONTEND=noninteractive  \
    apt-get install -y \
     --no-install-recommends \
      apt-transport-https \
      ca-certificates \
      gnupg

# From https://adoptium.net/installation/linux#_deb_installation_on_debian_or_ubuntu
# but with signing key placed in preferred apt-key location
chmod '=r' /etc/apt/trusted.gpg.d/adoptium.asc
echo "deb https://packages.adoptium.net/artifactory/deb $(awk -F= '/^VERSION_CODENAME/{print$2}' /etc/os-release) main" \
  > /etc/apt/sources.list.d/adoptium.list
apt-get update

DEBIAN_FRONTEND=noninteractive  \
    apt-get install -y \
     --no-install-recommends \
      bash \
      git \
      openssh-server \
      ssh-import-id \
      "temurin-${JDK_RELEASE}-jdk" \
      tini \
      tzdata
