[![Docker Pulls](https://img.shields.io/docker/pulls/itzg/ubuntu-remote-dev.svg)](https://hub.docker.com/r/itzg/ubuntu-remote-dev/)
[![ci](https://github.com/itzg/docker-ubuntu-remote-dev/actions/workflows/ci.yml/badge.svg)](https://github.com/itzg/docker-ubuntu-remote-dev/actions/workflows/ci.yml)

An Ubuntu based image that can be used with editors that support remote development over SSH.

Validated with:
- JetBrains Gateway

Includes:
- git
- JDK

## Usage

**Image name**: `itzg/ubuntu-remote-dev:20.04-17`

The image creates a user named `dev` with UID 1000, so assuming a local port binding of 2022 to the server's port, this can be used to connect to the container:

```shell
ssh -p 2022 dev@HOST
```

> Replace `HOST` with the actual host/IP of the container, such as "localhost"

### Environment variables

#### SSH_IMPORT_ID

**Required**: yes

User ID with protocol prefix supported by [ssh-import-id](https://manpages.ubuntu.com/manpages/focal/en/man1/ssh-import-id.1.html)

### Ports

#### 2022

SSH server

### Volumes

#### Workspace

**Mount point**: `/workspace`

Home directory of user `dev`

#### Pre-generated host keys

The volume `/host_keys` can be mounted and any files named `ssh_host_*_key` and `ssh_host_*_key.pub` will be used by SSHD. 

#### Extra SSHD configs

The volume `/sshd/configs.d` can be mounted and any files named `*.conf` will be included into the SSHD configuration.

### Command line

Any additional arguments will be passed to the `sshd` server command-line