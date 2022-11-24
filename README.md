# MLOps: desarrollo y operaciones de IA

Para poder seguir correctamente las instrucciones, tenemos que asegurarnos de tener exportadas las siguientes variables de entorno:

```bash
# Variables necesarias para construir la imagen con el CLI de AWS
export DOCKER_REGISTRY_USER_NAME="aacecandev"
export DOCKER_REGISTRY_IMAGE_NAME="awscli"
export DOCKER_REGISTRY_IMAGE_TAG="curso-mlops"

# Variables relacionadas con AWS
export AWS_DEFAULT_REGION="us-east-1"
export AWS_ACCOUNT_ID="123456789012" # $(aws sts get-caller-identity --query Account --output text)

```

También debemos crear un fichero `.aws/credentials` con las credenciales de AWS a partir de la plantilla `.aws/credentials.template`

**IMPORTANTE**

- Todos los scripts están pensados para ser ejecutados desde la raíz del repositorio.
- Los scripts de `bash` están pensados para ser ejecutados en un entorno Linux o Mac. Si se ejecutan en Windows, es posible que no funcionen correctamente.
- Si necesitamos ayuda con el CLI de AWS, o necesitamos usar la herramienta, podemos acceder a la ayuda de los comandos desde dentro del contenedor de AWS CLI con el comando `docker run -it --rm --entrypoint /bin/bash aacecandev/awscli:curso-mlops` y usando el formato `aws <comando> [subcomando, [...subcomando]] help`, por ejemplo `aws sagemaker help` o `aws sagemaker create-endpoint-config help`.
- Para poder simplificar el desarrollo del módulo, y con todos los prerequisitos mencionados anteriormente satisfechos, desarrollaremos el curso en un entorno de desarrollo basado en Docker. Para ello, ejecutaremos el script `./scripts/02-run-docker-awscli.sh` que nos creará un contenedor de Docker con todas las herramientas necesarias para poder desarrollar el curso. Para poder ejecutar los scripts de `bash` que se encuentran en el directorio `./scripts`, debemos ejecutarlos desde dentro del contenedor de desarrollo. Para ello, ejecutaremos el comando `./scripts/<nombre-del-script></nombre-del-script>`.

## 1. Creación de una imagen customizada con el CLI de AWS

En este primer paso vamos a generar una imagen con el CLI de AWS y a pushearla a nuestro registry privado en DockerHub. Esta imagen será desde la cual podremos lanzar todos los scripts para generar, actualizar y borrar infraestructura.

```bash
./scripts/01-build-docker-awscli.sh
```

## 2. Creación de un bucket S3

El primer paso para poder trabajar con SageMaker es crear un bucket S3 en el que almacenar los datos de entrada y los modelos de salida. Para ello practicaremos con la consola Web, el CLI de AWS y CloudFormation.

```bash
aws s3api create-bucket --bucket test-bucket-989282 --region us-east-1 # No funciona!
aws s3api create-bucket --bucket test-bucket-$(date +%s) --region us-east-1
```

### 2.1 ¿Cómo borrarías el bucket?

Intentemos borrar el bucket usando el CLI, ¿qué comandos utilizarías?

### 2.2 Ejercicio guiado: Creación de un bucket S3 con CloudFormation

En este ejercicio vamos a crear un bucket S3 con CloudFormation. Para ello, vamos a crear un fichero `cfn/01-s3-bucket.yml` con el siguiente contenido:

```yaml
AWSTemplateFormatVersion: '2010-09-09'
Description: 'S3 Bucket for MLOps course'
Parameters:
  Timestamp:
    Type: String
    Description: Timestamp
    Default: "1668970863"
Resources:
  S3Bucket:
    Type: AWS::S3::Bucket
    Properties:
      BucketName: !Sub "mlops-test-bucket-${Timestamp}"
# Outputs:
#   BucketName:
#     Description: Name of the S3 bucket
#     Value: !Ref S3Bucket
```

Y a aplicarlo con el siguiente comando:

```bash
aws cloudformation create-stack --stack-name test-bucket --template-body "file:///cfn/01-create-s3-bucket.yaml" --parameters "ParameterKey=Timestamp,ParameterValue=$(date +'%s')"
```

A continuación vamos a proceder a actualizar el stack para que produzca como salida el nombre del bucket creado. Para ello, descomentaremos la sección de Output del fichero YAML y ejecutaremos el siguiente comando:

```bash
aws cloudformation update-stack --stack-name test-bucket --template-body "file:///cfn/01-create-s3-bucket.yaml" --parameters "ParameterKey=Timestamp,ParameterValue=$(date +'%s')"
```

Podemos obtener el output con el nombre del bucket con el siguiente comando:

```bash
aws cloudformation describe-stacks --stack-name test-bucket --query "Stacks[0].Outputs[0].OutputValue" --output text
```

Podemos después borrar el stack ejecutando:

```bash
aws cloudformation delete-stack --stack-name test-bucket
```

## 3. Ejercicio 2 Creación de instancias EC2

En este ejercicio vamos a crear una instancia EC2 con el CLI de AWS y con CloudFormation. Como punto de partida tenemos que conseguir el ID de la VPC default así como el de alguna de sus subnets para emplazar en ellas la instancia EC2.

Tenemos que conseguir generar los siguientes componentes:

- SSH Key Pair con permisos Unix 400 (sólo lectura para el usuario propietario)
- Security Group con el puerto 22 abierto para nuestra IP pública
-


En primer lugar, seguiremos las instrucciones de la [documentación oficial sobre EC2 con CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-services-ec2.html) para crear todos los componentes necesarios de la instancia y poder conectarnos a ella.

En segundo lugar generaremos una plantilla de CloudFormation `cfn/02-ec2-instance.yml` y ejecutaremos los comandos necesarios para crear el stack, obtener el nombre de la instancia y por último, borrar el stack. Podemos encontrar ejemplos de todos los componentes en la [documentación oficial sobre snippets EC2 con CloudFormation](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/quickref-ec2.html).

## 4. Reseteo de la cuenta de AWS

En este ejercicio vamos a borrar todos los recursos que hemos creado en la cuenta de AWS para poder empezar de cero.

Para ello, vamos a utilizar la herramienta [aws-nuke](https://github.com/rebuy-de/aws-nuke)

Para utilizarla tenemos que revisar cuidadosamente los scripts que se facilitan con este módulo así como la configuración `nuke/config.yaml`, y ejecutarlos en el siguiente orden:

- `scripts/05-docker-nuke-dry-run.sh`
- `scripts/06-docker-nuke-no-dry-run.sh`

## 5. La importancia de las claves en AWS

En este ejercicio vamos a hablar de la importancia de las claves que utilizamos en nuestros repositorios, y repasaremos cómo podemos prevenir y reaccionar ante fugas de claves utilizando varias herramientas:

- [gitleaks](https://github.com/zricethezav/gitleaks)
- [pre-commit](https://pre-commit.com/)
- [sshgit](https://github.com/eth0izzle/shhgit)
- [bfg-repo-cleaner](https://rtyley.github.io/bfg-repo-cleaner/)
- aws-nuke + Github Actions


## 6. Ejercicio 3 Limpieza de secrets de nuestros repositorios

En este ejercicio vamos a limpiar los secrets de nuestros repositorios utilizando las herramientas que hemos visto en el ejercicio anterior.

Para ello, vamos a utilizar el repositorio de este módulo como ejemplo. Para ello, vamos a utilizar los siguientes comandos:

```bash
echo "my-super-secret-key" > .secrets
git add .secrets
git commit -m "Add secret"

docker run -v $(pwd):/path zricethezav/gitleaks:latest detect --source /path -v
```

Y a continuación, vamos a utilizar las herramientas que hemos visto en el ejercicio anterior para limpiar el repositorio de los secrets que hemos introducido. Para ello, usaremos el script `scripts/07-bfg-repo-cleaner.sh`.

## 7. IAM con AWS Python SDK

Para continuar, vamos a interactuar con la herramienta que nos falta dentro del conjunto de formas para interactuar con la API de AWS y el último de los servicios básicos que vamos a ver en este módulo en profundidad.

Para seguir el ejercicio usaremos el notebook `notebooks/01-aws-execution-role.ipynb`

## 8. Servicios gestionados en AWS

Durante el desarrollo de este apartado, vamos a hacer un repaso superficial por todos los servicios autogestionados que nos ofrece AWS, y pararemos en dos específicos para verlos en profundidad. Para el desarrollo de este apartado, vamos a utilizar un entorno de ejecución de SageMaker Studio desde el cual ejecutaremos los notebook

- `notebooks/02-managed-services.ipynb`
- `notebooks/03-sagemaker.ipynb`

Para poder trabajar correctamente con ellos, haremos un fork de este repositorio en nuestro propio perfil de Github, y crearemos un nuevo entorno de ejecución de SageMaker Studio desde el cual podremos trabajar con los notebooks.

Una vez inicializado SageMaker, procederemos a clonar desde una terminal del sistema el repositorio. Para ello, ejecutaremos los siguientes comandos:

```bash
# Creamos una clave SSH, copiamos la clave pública y la añadimos a nuestro perfil de Github y testeamos
ssh-keygen -t rsa -b 4096 -C "sagemaker" -f .ssh/id_rsa
cat .ssh/id_rsa.pub
ssh -T git@github.com

# Clonamos nuestro propio fork dentro de SageMaker
git clone git@github/<user>/mlops-desarrollo-y-operaciones-de-inteligencia-artificial.git
```

Si durante la clase se modificasen los ficheros del repositorio, podemos obtener una copia actualizada de los mismos ejecutando el siguiente comando:

```bash
git remote add upstream git@github.com:aacecandev/mlops-desarrollo-y-operaciones-de-inteligencia-artificial.git
git fetch upstream
git checkout main
git rebase upstream/main
```

Toda la documentación sobre gestión de claves SSH podemos encontrarla en el siguiente [enlace de Github](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/testing-your-ssh-connection)

## 8. Intro & Arquitectura de SageMaker

En esta parte del módulo vamos a repasar de forma teórico-práctica los conceptos básicos de SageMaker, y vamos a interactuar con el servicio a través de la consola Web de AWS y de las APIs disponibles para conocer un poco mejor el servicio.

- [[AWS] What Is Amazon SageMaker?](https://docs.aws.amazon.com/sagemaker/latest/dg/whatis.html)

### 8.1 Desplegando laboratorios SageMaker Classic & Studio

- [[Github] Sample Scripts to Customize SageMaker Notebook Instance](https://github.com/aws-samples/amazon-sagemaker-notebook-instance-customization)

### 8.2 Arquitectura de SageMaker


- [[AWS] Prebuilt SageMaker Docker Images for Deep Learning](https://docs.aws.amazon.com/sagemaker/latest/dg/pre-built-containers-frameworks-deep-learning.html)

### 8.x SageMaker Studio vs SageMaker Classic

- [[AWS] How Are Amazon SageMaker Studio Notebooks Different from Notebook Instances?](https://docs.aws.amazon.com/sagemaker/latest/dg/notebooks-comparison.html)

### 8.3 SageMaker Classic Custom



### 8.4 SageMaker Studio Custom

- [[AWS] SageMaker Studio Custom Image Samples](https://github.com/aws-samples/sagemaker-studio-custom-image-samples)
  - [[Github] SageMaker Studio Custom Image Samples](https://github.com/aws-samples/sagemaker-studio-custom-image-samples)

### 8.4 SageMaker Lifecycle Configuration

- [[AWS] Create a Lifecycle Configuration from the AWS CLI](https://docs.aws.amazon.com/sagemaker/latest/dg/studio-lcc-create-cli.html)
- [[Github] SageMaker Studio Lifecycle Configuration Samples](https://github.com/aws-samples/sagemaker-studio-lifecycle-config-**examples**)

## References

- [[AWS] Machine Learning Free Tier](https://aws.amazon.com/free/?all-free-tier.sort-by=item.additionalFields.SortRank&all-free-tier.sort-order=asc&awsf.Free%20Tier%20Types=*all&awsf.Free%20Tier%20Categories=categories%23ai-ml)

- [[AWS] Build environment compute types](https://docs.aws.amazon.com/codebuild/latest/userguide/build-env-ref-compute-types.html)

- [[Github] Jupyter Docker Stacks](https://github.com/jupyter/docker-stacks)


- [[Github] AWS EFA and NCCL Base AMI/Docker Build Pipeline](https://github.com/aws-samples/aws-efa-nccl-baseami-pipeline)
- [[Github] AWS Samples](https://github.com/aws-samples)

- [[AWS] Amazon SageMaker Studio Pricing](https://docs.aws.amazon.com/sagemaker/latest/dg/studio-pricing.html)

- [[AWS] Use Lifecycle Configurations with Amazon SageMaker Studio](https://docs.aws.amazon.com/sagemaker/latest/dg/studio-lcc.html)

- [[AWS] Use Amazon SageMaker Studio Notebooks](https://docs.aws.amazon.com/sagemaker/latest/dg/notebooks.html)



- [[Github] SageMaker-Studio-Autoshutdown-Extension](https://github.com/aws-samples/sagemaker-studio-auto-shutdown-extension)


- [[Towards Data Science] Customizing SageMaker Studio](https://towardsdatascience.com/run-setup-scripts-automatically-on-sagemaker-studio-15222b9d2f8c)
- [[AWS] Bringing your own custom container image to Amazon SageMaker Studio notebooks](https://aws.amazon.com/blogs/machine-learning/bringing-your-own-custom-container-image-to-amazon-sagemaker-studio-notebooks/)
- [[AwsTut] Delete ECR images using CloudFormation Custom Resources](https://awstut.com/en/2022/08/27/delete-ecr-images-using-cloudformation-custom-resources-en/)
- [[AWS] Attach a custom SageMaker image](https://docs.aws.amazon.com/sagemaker/latest/dg/studio-byoi-attach.html)
- [[Towards Data Science] Automating the Setup of SageMaker Studio Custom Images](https://towardsdatascience.com/automating-the-setup-of-sagemaker-studio-custom-images-4a3433fd7148)

- [[Github] Issue, Attach custom image to SageMaker domain without update-domain command](https://github.com/aws/aws-sdk/issues/367)
- [[AWS] Launch a custom SageMaker image in Amazon SageMaker Studio](https://docs.aws.amazon.com/sagemaker/latest/dg/studio-byoi-launch.html)
- [[AWS] Customize Amazon SageMaker Studio using Lifecycle Configurations](https://aws.amazon.com/blogs/machine-learning/customize-amazon-sagemaker-studio-using-lifecycle-configurations/)
- [[Github] SageMaker Studio Lifecycle Configuration Samples](https://github.com/aws-samples/sagemaker-studio-lifecycle-config-examples#sagemaker-studio-lifecycle-configuration-samples)
- [[AWS] Host code-server on Amazon SageMaker](https://aws.amazon.com/blogs/machine-learning/host-code-server-on-amazon-sagemaker/)
- [[Github] https://github.com/aws-samples/amazon-sagemaker-codeserver#code-server-on-amazon-sagemaker](https://github.com/aws-samples/amazon-sagemaker-codeserver)

### AWS Comprehend

- [AWS, What is Amazon Comprehend?](https://docs.aws.amazon.com/comprehend/latest/dg/what-is.html)
- [AWS, Languages supported in Amazon Comprehend](https://docs.aws.amazon.com/comprehend/latest/dg/supported-languages.html)


## Further Reading

- [AWS, Secure Data Science with Amazon SageMaker Studio Workshop](https://catalog.us-east-1.prod.workshops.aws/workshops/c882cd42-8ec8-4112-9469-9fab33471e85/en-US)
- [Github, AWS CloudFormation resource providers SageMaker](https://github.com/aws-cloudformation/aws-cloudformation-resource-providers-sagemaker)
- [AWS, Amazon SageMaker Fridays](https://pages.awscloud.com/SageMakerFridays)
- [YouTube, Kubeflow + BERT + TensorFlow + PyTorch + Reinforcement Learning +Multi-arm Bandits +Amazon SageMaker](https://www.youtube.com/watch?v=9_SWaKdZhEM)
- [Gitub, awesome-sagemaker](https://github.com/aws-samples/awesome-sagemaker)
