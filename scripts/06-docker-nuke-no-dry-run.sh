#!/bin/bash

AWS_CREDENTIALS_FOLDER=.aws
NUKE_CONFIG_RAW=nuke/config.yaml
NUKE_CONFIG_PROCESSED_FILE=nuke/config-dont-upload.yaml

sed "s/AWS_ACCOUNT_ID_REPLACE_ME/${AWS_ACCOUNT_ID}/" "${NUKE_CONFIG_RAW}" > "${NUKE_CONFIG_PROCESSED_FILE}"

docker run \
--rm \
--interactive \
--tty \
--volume "$(pwd)/${NUKE_CONFIG_PROCESSED_FILE}":/home/aws-nuke/config-dont-upload.yaml \
--volume "$(pwd)/${AWS_CREDENTIALS_FOLDER}":/home/aws-nuke/.aws \
quay.io/rebuy/aws-nuke:v2.20.0 \
--profile default \
--config /home/aws-nuke/config-dont-upload.yaml \
--quiet \
--force \
--no-dry-run
