#!/usr/bin/env bash
set -x

image_name=$1
tag=$2

# check arguments, IMAGE_NAME 
if [ -z "${1}" ] ; then
    echo "ERROR! Missing IMAGE_NAME"
    exit 99
# check arguments, IMAGE_NAME 
elif [ -z "${2}" ] ; then
    tag=${CODEBUILD_START_TIME}
# check arguments, IMAGE_CONFIG 
elif [ -z "${IMAGE_CONFIG}" ] ; then
    echo "Missing IMAGE_CONFIG from Environment"
    exit 99
fi

# Define variables
ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output=text)
image_uri="${ACCOUNT_ID}.dkr.ecr.${REGION}.amazonaws.com/${image_name}:${tag}"

cd docker

# Create Image version for Studio
aws sagemaker create-image-version \
  --image-name ${IMAGE_NAME} \
  --base-image ${image_uri}

# Create AppImageConfig for this image
aws sagemaker delete-app-image-config \
  --app-image-config-name ${IMAGE_CONFIG}

aws sagemaker create-app-image-config \
  --cli-input-json file://app-image-config-input.json

# Update the Domain, providing the Image and AppImageConfig
aws sagemaker update-domain \
  --domain-id ${DOMAIN_ID} \
  --cli-input-json file://update-domain-input.json

