#!/bin/bash
set -e

mkdir -p /run/sshd

if [ -n "$SSH_PUBLIC_KEY" ]; then
    echo "SSH_PUBLIC_KEY environment variable found, configuring SSH access."

    mkdir -p /root/.ssh

    echo "$SSH_PUBLIC_KEY" > /root/.ssh/authorized_keys

    chmod 700 /root/.ssh
    chmod 600 /root/.ssh/authorized_keys
else
    echo "WARNING: No SSH_PUBLIC_KEY environment variable found. SSH access will not be configured."
fi

exec /usr/sbin/sshd -D
