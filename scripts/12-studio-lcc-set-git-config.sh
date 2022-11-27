#!/bin/bash

DOMAIN_ID=$(aws sagemaker list-domains | jq -r '.Domains[0] | .DomainId')
USER_PROFILE_NAME=$(aws sagemaker list-user-profiles | jq -r '.UserProfiles[0] | .UserProfileName')
LCC_CONFIG_NAME=set-git-config
LCC_CONTENT=$(openssl base64 -A -in studio/install-git-repo.sh)

# Delete the existing Lifecycle Configuration
aws sagemaker delete-studio-lifecycle-config --studio-lifecycle-config-name ${LCC_CONFIG_NAME} || true

aws sagemaker create-studio-lifecycle-config \
--studio-lifecycle-config-name "${LCC_CONFIG_NAME}" \
--studio-lifecycle-config-content "${LCC_CONTENT}" \
--studio-lifecycle-config-app-type JupyterServer \
--query 'StudioLifecycleConfigArn' || true

aws sagemaker update-user-profile --domain-id "${DOMAIN_ID}" \
--user-profile-name "${USER_PROFILE_NAME}" \
--user-settings "{
\"JupyterServerAppSettings\": {
  \"DefaultResourceSpec\": {
    \"LifecycleConfigArn\": \"arn:aws:sagemaker:${AWS_DEFAULT_REGION}:${AWS_ACCOUNT_ID}:studio-lifecycle-config/set-git-config\",
    \"InstanceType\": \"system\"
  },
  \"LifecycleConfigArns\": [
    \"arn:aws:sagemaker:${AWS_DEFAULT_REGION}:${AWS_ACCOUNT_ID}:studio-lifecycle-config/set-git-config\"
  ]
}}"

aws sagemaker update-domain \
--region "${AWS_DEFAULT_REGION}" \
--domain-id "${DOMAIN_ID}" \
--default-user-settings "{
\"JupyterServerAppSettings\": {
  \"DefaultResourceSpec\": {
    \"LifecycleConfigArn\": \"arn:aws:sagemaker:${AWS_DEFAULT_REGION}:${AWS_ACCOUNT_ID}:studio-lifecycle-config/set-git-config\",
    \"InstanceType\": \"system\"
  },
  \"LifecycleConfigArns\": [
    \"arn:aws:sagemaker:${AWS_DEFAULT_REGION}:${AWS_ACCOUNT_ID}:studio-lifecycle-config/set-git-config\"
  ]
}}"
