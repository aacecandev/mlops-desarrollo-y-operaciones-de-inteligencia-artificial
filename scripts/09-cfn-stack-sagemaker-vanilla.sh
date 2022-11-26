#!/bin/bash

STACK_NAME="sagemaker-vanilla"
CFN_TEMPLATE_FILE_PATH="cfn/05-create-sagemaker-vanilla.yaml"

aws cloudformation deploy \
  --stack-name "${STACK_NAME}" \
  --template-file "${CFN_TEMPLATE_FILE_PATH}" \
  --region="${AWS_DEFAULT_REGION}" \
  --capabilities CAPABILITY_NAMED_IAM

# aws cloudformation delete-stack \
#   --stack-name "${STACK_NAME}" \
#   --region="${AWS_DEFAULT_REGION}"
