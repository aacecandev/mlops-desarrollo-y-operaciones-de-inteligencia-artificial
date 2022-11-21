#!/bin/bash


## Creación del bucket S3 desde el contenedor con AWS CLI y cleanup
aws s3api create-bucket --bucket test-bucket-989282 --region us-east-1 # No funciona!
aws s3api create-bucket --bucket test-bucket-$(date +%s) --region us-east-1
aws s3api list-buckets
aws s3api delete-bucket --bucket test-bucket-1668966900 --region us-east-1

# Creacion del stack de CloudFormation
aws cloudformation create-stack --stack-name test-bucket --template-body "file:///cfn/01-create-s3-bucket.yaml" --parameters "ParameterKey=Timestamp,ParameterValue=$(date +'%s')"

# Actualización del stack de CloudFormation
aws cloudformation update-stack --stack-name test-bucket --template-body "file:///cfn/01-create-s3-bucket.yaml" --parameters "ParameterKey=Timestamp,ParameterValue=$(date +'%s')"

# Obtención del nombre del bucket S3
aws cloudformation describe-stacks --stack-name test-bucket --query "Stacks[0].Outputs[0].OutputValue" --output text

# Eliminación del stack de CloudFormation
aws cloudformation delete-stack --stack-name test-bucket
