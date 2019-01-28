#!/bin/bash
set -eou pipefail

if [ -z "$(command -v conjur)" ]; then
    echo "Please install and configure the CyberArk Conjur CLI before running this again."
    exit 1
fi

conjur policy load root root.yml
host_id = $(conjur policy load jenkins-frontend jenkins-frontend.yml)
conjur policy load gsc gsc.yml
conjur policy load github github.yml

echo "++++++++++++++++++++++++++++++"
echo "Please remember to initialize the secret variables created by policy load."
echo "++++++++++++++++++++++++++++++"
echo "PLEASE SAVE THIS SOMEWHERE SAFE"
echo "++++++++++++++++++++++++++++++"
echo "Your Jenkins Host Identity is:"
echo "${host_id}"