#!/usr/bin/env bash
set -eu

: "${SSH_IMPORT_ID?Authorized public keys are required to access}"

userAuthKeys="${DEV_USER_HOME}/.ssh/authorized_keys"
if [[ ${SSH_IMPORT_ID:-} ]]; then
  echo "Importing SSH public keys from $SSH_IMPORT_ID"
  ssh-import-id --output "$userAuthKeys" "$SSH_IMPORT_ID"
  chown -R "${DEV_USER_NAME}:" "${DEV_USER_HOME}/.ssh"
  chmod 'u=rw,go=' "$userAuthKeys"
fi

rm -f /etc/ssh/ssh_host_*
ssh-keygen -A

echo "Server fingerprints:"
for file in /etc/ssh/ssh_host_*_key.pub; do
  ssh-keygen -lvf "$file"
done

mkdir -p /run/sshd
/usr/sbin/sshd -t

chown "$DEV_USER_NAME" "$DEV_USER_HOME"

ls -ld "$DEV_USER_HOME"
ls -la "$DEV_USER_HOME" "$DEV_USER_HOME/.ssh"

echo "Running sshd $*"
# Using tini since sshd on its own didn't handle Ctrl-C
exec tini -- /usr/sbin/sshd -e -D "${@}"