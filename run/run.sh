#!/usr/bin/env bash
set -eu
shopt -s nullglob

: "${SSH_IMPORT_ID?Authorized public keys are required to access}"

userAuthKeys="${DEV_USER_HOME}/.ssh/authorized_keys"
if [[ ${SSH_IMPORT_ID:-} ]]; then
  echo "Importing SSH public keys from $SSH_IMPORT_ID"
  ssh-import-id --output "$userAuthKeys" "$SSH_IMPORT_ID"
  chown -R "${DEV_USER_NAME}:" "${DEV_USER_HOME}/.ssh"
  chmod 'u=rw,go=' "$userAuthKeys"
fi

# bring over pre-generated
if (( $(find /host_keys -mindepth 1 -maxdepth 1 -type f -name 'ssh_host_*' | wc -l) > 0 )); then
  cp --verbose --target-directory=/etc/ssh/ \
    /host_keys/ssh_host_*_key /host_keys/ssh_host_*_key.pub
  chmod 'go=' /etc/ssh/ssh_host_*_key
fi

# and backfill any others
ssh-keygen -A

echo "Server fingerprints:"
for file in /etc/ssh/ssh_host_*_key.pub; do
  ssh-keygen -lvf "$file"
done

# privilege separation directory
mkdir -p /run/sshd

/usr/sbin/sshd -t -f "/sshd/dev.conf"

chown "$DEV_USER_NAME" "$DEV_USER_HOME"

echo "Running sshd $*"
# Using tini since sshd on its own didn't handle Ctrl-C
exec tini -- /usr/sbin/sshd -e -D -f "/sshd/dev.conf" "${@}"