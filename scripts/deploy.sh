#!/bin/bash

set -e

if [[ $DEPLOY_USER == "" || $DEPLOY_SERVER == "" || $DEPLOY_KEY == "" || $DEPLOY_CMD == "" ]]; then
    echo "Not configured properly."
    exit 1
fi

if [[ $TRAVIS_BRANCH != "master" ]]; then
    exit 0
fi

mkdir -p ~/.ssh
echo "$DEPLOY_KEY" > ~/.ssh/id_rsa
chmod 400 ~/.ssh/id_rsa

if ! ssh $DEPLOY_USER@$DEPLOY_SERVER $DEPLOY_CMD; then
    echo "Failed to deploy"
    exit 1
fi
