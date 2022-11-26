#!/bin/bash

STACK_NAME="${1:-sagemaker-notebook-classic}"
CFN_TEMPLATE_FILE_PATH="cfn/03-create-sagemaker-notebook-classic.yaml"
CFN_TEMPLATE_CUSTOMIZED_FILE_PATH="cfn/04-create-sagemaker-notebook-classic-with-customization.yaml"

aws cloudformation deploy \
  --stack-name "${STACK_NAME}" \
  --template-file "${CFN_TEMPLATE_FILE_PATH}" \
  --region="${AWS_DEFAULT_REGION}" \
  --capabilities CAPABILITY_NAMED_IAM

# aws cloudformation deploy \
#   --stack-name "${STACK_NAME}" \
#   --template-file "${CFN_TEMPLATE_CUSTOMIZED_FILE_PATH}" \
#   --region="${AWS_DEFAULT_REGION}" \
#   --capabilities CAPABILITY_NAMED_IAM

# aws cloudformation delete-stack \
#   --stack-name "${STACK_NAME}" \
#   --region="${AWS_DEFAULT_REGION}"
