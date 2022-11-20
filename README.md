# MLOps: desarrollo y operaciones de IA

Para poder seguir correctamente las instrucciones, tenemos que asegurarnos de tener exportadas las siguientes variables de entorno:

```bash
# Variables necesarias para construir la imagen con el CLI de AWS
export REGISTRY_USER_NAME="aacecandev"
export REGISTRY_IMAGE_NAME="awscli"
export REGISTRY_IMAGE_TAG="curso-mlops"

```

**IMPORTANTE**

Todos los comandos están pensados para ser ejecutados desde la raíz del repositorio.

## 1. Creación de una imagen customizada con el CLI de AWS

```bash
./modulo7-mlops-y-cloud-computing/scripts/build-docker-awscli.sh
```
## References

- [AWS, Build environment compute types](https://docs.aws.amazon.com/codebuild/latest/userguide/build-env-ref-compute-types.html)
- [Github, SageMaker Studio Custom Image Samples](https://github.com/aws-samples/sagemaker-studio-custom-image-samples)
- [Github, Jupyter Docker Stacks](https://github.com/jupyter/docker-stacks)
- [AWS, SageMaker Studio Custom Image Samples](https://github.com/aws-samples/sagemaker-studio-custom-image-samples)
- [AWS, Prebuilt SageMaker Docker Images for Deep Learning](https://docs.aws.amazon.com/sagemaker/latest/dg/pre-built-containers-frameworks-deep-learning.html)
- [Github, AWS EFA and NCCL Base AMI/Docker Build Pipeline](https://github.com/aws-samples/aws-efa-nccl-baseami-pipeline)
- [Github, AWS Samples](https://github.com/aws-samples)
- [Github, Sample Scripts to Customize SageMaker Notebook Instance](https://github.com/aws-samples/amazon-sagemaker-notebook-instance-customization)
- [AWS, How Are Amazon SageMaker Studio Notebooks Different from Notebook Instances?](https://docs.aws.amazon.com/sagemaker/latest/dg/notebooks-comparison.html)
- [AWS, Amazon SageMaker Studio Pricing](https://docs.aws.amazon.com/sagemaker/latest/dg/studio-pricing.html)
- [AWS, Machine Learning Free Tier](https://aws.amazon.com/free/?all-free-tier.sort-by=item.additionalFields.SortRank&all-free-tier.sort-order=asc&awsf.Free%20Tier%20Types=*all&awsf.Free%20Tier%20Categories=categories%23ai-ml)
- [AWS, Use Lifecycle Configurations with Amazon SageMaker Studio](https://docs.aws.amazon.com/sagemaker/latest/dg/studio-lcc.html)
- [AWS, Use Amazon SageMaker Studio Notebooks](https://docs.aws.amazon.com/sagemaker/latest/dg/notebooks.html)
- [AWS, Create a Lifecycle Configuration from the AWS CLI](https://docs.aws.amazon.com/sagemaker/latest/dg/studio-lcc-create-cli.html)
- [Github, SageMaker-Studio-Autoshutdown-Extension](https://github.com/aws-samples/sagemaker-studio-auto-shutdown-extension)
- [Github, SageMaker Studio Lifecycle Configuration Samples](https://github.com/aws-samples/sagemaker-studio-lifecycle-config-**examples**)
- [Towards Data Science, Customizing SageMaker Studio](https://towardsdatascience.com/run-setup-scripts-automatically-on-sagemaker-studio-15222b9d2f8c)
- [AWS, Bringing your own custom container image to Amazon SageMaker Studio notebooks](https://aws.amazon.com/blogs/machine-learning/bringing-your-own-custom-container-image-to-amazon-sagemaker-studio-notebooks/)
- [AwsTut, Delete ECR images using CloudFormation Custom Resources](https://awstut.com/en/2022/08/27/delete-ecr-images-using-cloudformation-custom-resources-en/)
- [AWS, Attach a custom SageMaker image](https://docs.aws.amazon.com/sagemaker/latest/dg/studio-byoi-attach.html)
- [Towards Data Science, Automating the Setup of SageMaker Studio Custom Images](https://towardsdatascience.com/automating-the-setup-of-sagemaker-studio-custom-images-4a3433fd7148)
- [AWS, What Is Amazon SageMaker?](https://docs.aws.amazon.com/sagemaker/latest/dg/whatis.html)
- [Github, Issue, Attach custom image to SageMaker domain without update-domain command](https://github.com/aws/aws-sdk/issues/367)
- [AWS, Launch a custom SageMaker image in Amazon SageMaker Studio](https://docs.aws.amazon.com/sagemaker/latest/dg/studio-byoi-launch.html)
- [AWS, Customize Amazon SageMaker Studio using Lifecycle Configurations](https://aws.amazon.com/blogs/machine-learning/customize-amazon-sagemaker-studio-using-lifecycle-configurations/)
- [Github, SageMaker Studio Lifecycle Configuration Samples](https://github.com/aws-samples/sagemaker-studio-lifecycle-config-examples#sagemaker-studio-lifecycle-configuration-samples)
- [AWS, Host code-server on Amazon SageMaker](https://aws.amazon.com/blogs/machine-learning/host-code-server-on-amazon-sagemaker/)
- [Github, https://github.com/aws-samples/amazon-sagemaker-codeserver#code-server-on-amazon-sagemaker](https://github.com/aws-samples/amazon-sagemaker-codeserver)

### AWS Comprehend

- [AWS, What is Amazon Comprehend?](https://docs.aws.amazon.com/comprehend/latest/dg/what-is.html)
- [AWS, Languages supported in Amazon Comprehend](https://docs.aws.amazon.com/comprehend/latest/dg/supported-languages.html)


## Further Reading

- [AWS, Secure Data Science with Amazon SageMaker Studio Workshop](https://catalog.us-east-1.prod.workshops.aws/workshops/c882cd42-8ec8-4112-9469-9fab33471e85/en-US)
- [Github, AWS CloudFormation resource providers SageMaker](https://github.com/aws-cloudformation/aws-cloudformation-resource-providers-sagemaker)
- [AWS, Amazon SageMaker Fridays](https://pages.awscloud.com/SageMakerFridays)
- [YouTube, Kubeflow + BERT + TensorFlow + PyTorch + Reinforcement Learning +Multi-arm Bandits +Amazon SageMaker](https://www.youtube.com/watch?v=9_SWaKdZhEM)
- [Gitub, awesome-sagemaker](https://github.com/aws-samples/awesome-sagemaker)
