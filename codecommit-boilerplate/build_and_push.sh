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
    echo "Missing TAG_NAME"
    exit 99
fi

##### NOTHING-TO-EDIT-BELOW-THIS-LINE #####
ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output=text)
fullname="${ACCOUNT_ID}.dkr.ecr.${REGION}.amazonaws.com/${IMAGE_NAME}:${tag}"

# Get the version of aws-cli, needs AWSv2
aws --version

# Get the login command from ECR and execute it directly
aws ecr get-login-password \
    --region ${REGION} \
    | docker login \
    --username AWS \
    --password-stdin ${ACCOUNT_ID}.dkr.ecr.${REGION}.amazonaws.com

# If unable to login, do not proceed
[ $? != 0 ] && exit 99

# If the repository doesn't exist in ECR, create it.
aws ecr describe-repositories \
    --repository-names ${IMAGE_NAME} \
    || aws ecr create-repository \
    --repository-name ${IMAGE_NAME}

# Build the docker image locally and then push it to ECR with the full name.
echo "BUILDING IMAGE WITH NAME ${IMAGE_NAME} AND TAG ${tag}"

cd docker

docker build --no-cache \
    -t ${IMAGE_NAME} \
    -f Dockerfile .

docker tag ${image_name} ${fullname}

# Push to ECR
echo "PUSHING IMAGE TO ECR ECR ${fullname}"

docker push ${fullname}
