#!/bin/bash

# Obtener ayuda sobre el comando aws ec2
aws ec2 help

# Generamos el par de claves para la instancia EC2
aws ec2 create-key-pair --key-name MyKeyPair --query 'KeyMaterial' --output text > MyKeyPair.pem

# Le damos permisos de lectura al par de claves
chmod 400 MyKeyPair.pem

# Obtenemos los datos del par de claves creado
aws ec2 describe-key-pairs --key-name MyKeyPair

# Obtenemos el vpc-id de la VPC por defecto
VPC_ID=$(aws ec2 describe-vpcs --filters Name=isDefault,Values=true --query 'Vpcs[0].VpcId' --output text)

# Obtenemos el subnet-id de la primera subnet de la VPC por defecto
SUBNET_ID=$(aws ec2 describe-subnets --filters Name=vpc-id,Values=${VPC_ID} --query 'Subnets[*].SubnetId' --output json | jq --raw-output '.[0]')

# Generamos un Security Group en la VPC por defecto
aws ec2 create-security-group --group-name MySecurityGroup --description "My security group" --vpc-id ${VPC_ID}

# Obtenemos el security-group-id del Security Group creado
SG_ID=$(aws ec2 describe-security-groups --filters Name=vpc-id,Values=${VPC_ID} Name=group-name,Values=MySecurityGroup --query 'SecurityGroups[*].GroupId' --output text)

# Conseguimos nuestra IP
MY_IP=$(curl https://checkip.amazonaws.com)

# Abrimos el puerto 22 para nuestra IP
aws ec2 authorize-security-group-ingress --group-id ${SG_ID} --protocol tcp --port 22 --cidr ${MY_IP}/32

# Obtenemos el ID de la AMI de Ubuntu 18.04
AMI_ID=$(aws ec2 describe-images --owners self amazon --filters "Name=name,Values=ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*" | jq --raw-output '.Images[0] .ImageId')

# Creamos la instancia EC2
aws ec2 run-instances --image-id ${AMI_ID} --count 1 --instance-type t2.micro --key-name MyKeyPair --security-group-ids ${SG_ID} --subnet-id ${SUBNET_ID}

# Obtenemos el ID de la instancia EC2
INSTANCE_ID=$(aws ec2 describe-instances --filters "Name=instance-type,Values=t2.micro" --query "Reservations[].Instances[].InstanceId" --output text)

# Obtenemos la IP pública de la instancia EC2
PUBLIC_IP=$(aws ec2 describe-instances --instance-ids ${INSTANCE_ID} --query "Reservations[].Instances[].PublicIpAddress" --output text)

# Esperamos a que la instancia EC2 esté lista
aws ec2 wait instance-status-ok --instance-ids ${INSTANCE_ID}

# Conectamos a la instancia EC2
ssh -i MyKeyPair.pem ubuntu@${PUBLIC_IP}

# Terminamos la instancia EC2
aws ec2 wait terminate-instances --instance-ids ${INSTANCE_ID}

# Borramos el security group
aws ec2 delete-security-group --group-id ${SG_ID}

# Borramos el par de claves
aws ec2 delete-key-pair --key-name MyKeyPair

### DESPLIEGUE DE LA INSTANCIA USANDO CLOUDFORMATION

# Obtenemos una plantilla con los parametros necesarios para crear una instancia EC2
docker run -it --rm --volume "$(pwd)/cfn":/cfn --workdir /cfn golang:latest bash
go install github.com/awslabs/aws-cloudformation-template-builder/cmd/cfn-skeleton@master
cfn-skeleton AWS::EC2::SecurityGroup AWS::EC2::Instance > 02-create-ec2-instance.yaml

# Generamos un SSH Key Pair para la instancia EC2
aws ec2 create-key-pair --key-name MyKeyPair --query 'KeyMaterial' --output text > MyKeyPair.pem
chmod 400 MyKeyPair.pem

# Conseguimos de nuevo los IDs de la VPC y la subnet, nuestra IP y el ID de la AMI de Ubuntu 18.04
VPC_ID=$(aws ec2 describe-vpcs --filters Name=isDefault,Values=true --query 'Vpcs[0].VpcId' --output text)
SUBNET_ID=$(aws ec2 describe-subnets --filters Name=vpc-id,Values=${VPC_ID} --query 'Subnets[*].SubnetId' --output json | jq --raw-output '.[0]')
MY_IP=$(curl https://checkip.amazonaws.com)
AMI_ID=$(aws ec2 describe-images --owners self amazon --filters "Name=name,Values=ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*" | jq --raw-output '.Images[0] .ImageId')

# Después de limpiar la template para conseguir el estado deseado, creamos el stack de CloudFormation
aws cloudformation create-stack \
--stack-name test-ec2 \
--template-body "file:///cfn/02-create-ec2-instance.yaml" \
--parameters "ParameterKey=DefaultVpcId,ParameterValue=${VPC_ID}" \
  "ParameterKey=DefaultSubnetId,ParameterValue=${SUBNET_ID}" \
  "ParameterKey=MyIp,ParameterValue=${MY_IP}" \
  "ParameterKey=AmiId,ParameterValue=${AMI_ID}"

# Obtenemos el ID del keypair de AWS Systems Manager Parameter Store
KEYPAIR_ID=$(aws ssm describe-parameters --query 'Parameters[0].Name' --output text)
chmod 400 MyKeyPair.pem

# Obtenemos la parte privada del juego de claves de AWS Systems Manager
aws ssm get-parameter --name ${KEYPAIR_ID} --with-decryption --query 'Parameter.Value' --output text > MyKeyPair.pem

# Obtenemos la IP pública de la instancia EC2
PUBLIC_IP=$(aws cloudformation describe-stacks --stack-name test-ec2 --query 'Stacks[0].Outputs[?OutputKey==`MyInstancePublicIp`].OutputValue' --output text)

# Testeamos si recibimos respuesta de Apache
curl http://${PUBLIC_IP}
