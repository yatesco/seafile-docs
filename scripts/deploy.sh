#!/bin/bash

set -e

if [[ $DEPLOY_USER == "" || $DEPLOY_SERVER == "" || $DEPLOY_CMD == "" ]]; then
    echo "Not configured properly."
    exit 1
fi

if [[ $TRAVIS_BRANCH != "master" ]]; then
    exit 0
fi

mkdir -p ~/.ssh
openssl aes-256-cbc -K $encrypted_0138e8c4859f_key -iv $encrypted_0138e8c4859f_iv -in scripts/key.txt.enc -out ~/.ssh/id_rsa -d
chmod 400 ~/.ssh/id_rsa

do_ssh() {
    ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no "$@"
}

if ! do_ssh $DEPLOY_USER@$DEPLOY_SERVER $DEPLOY_CMD seafile-docs; then
    echo "Failed to deploy"
    exit 1
fi
