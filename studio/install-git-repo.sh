#!/bin/bash

# This scripts sets username and email address in Git config

# stop the script execution on error
set -e

# PARAMETERS
GIT_USER_NAME="aacecandev"
GIT_EMAIL_ADDRESS="dev@aacecan.com"
export GIT_REPO_URL="https://github.com/aacecandev/mlops-desarrollo-y-operaciones-de-inteligencia-artificial.git"

git config --global user.name "${GIT_USER_NAME}"
git config --global user.email "${GIT_EMAIL_ADDRESS}"

git -C /home/sagemaker-user clone "${GIT_REPO_URL}"
