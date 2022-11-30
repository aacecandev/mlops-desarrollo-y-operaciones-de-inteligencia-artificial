#!/bin/bash

# Podemos descomentar esta linea y las dos últimas para ejecutar los scripts sin necesidad de
# entrar en el entorno de ejecución del contenedor

# SCRIPT=$(readlink -f "$0")

CLOUDFORMATION_FOLDER=cfn
SCRIPTS_FOLDER=scripts
STUDIO_FOLDER=studio
NOTEBOOKS_FOLDER=notebooks

docker run \
--rm \
--interactive \
--tty \
--env AWS_DEFAULT_REGION="${AWS_DEFAULT_REGION}" \
--env AWS_ACCOUNT_ID="${AWS_ACCOUNT_ID}" \
--volume "$(pwd)/${CLOUDFORMATION_FOLDER}":/cfn \
--volume "$(pwd)/${SCRIPTS_FOLDER}":/scripts \
--volume "$(pwd)/${STUDIO_FOLDER}":/studio \
--volume "$(pwd)/${NOTEBOOKS_FOLDER}":/notebooks \
--volume "$(pwd)"/.aws:/root/.aws \
--workdir / \
--entrypoint /bin/bash \
"${DOCKER_REGISTRY_USER_NAME}/${DOCKER_REGISTRY_IMAGE_NAME}:${DOCKER_REGISTRY_IMAGE_TAG}"
# \
# -c "cd /scripts && export AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text) ${SCRIPT}"
