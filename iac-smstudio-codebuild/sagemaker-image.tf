## IMAGE
resource "aws_sagemaker_image" "custom" {
  image_name = "smstudio-${var.image_name}"
  role_arn   = aws_iam_role.codebuild.arn
}


## ECR-REPOSITORY
resource "aws_ecr_repository" "custom" {
  name = "smstudio-${var.image_name}"
  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
     scan_on_push = true
  }
}


## ECR LIFECYCLE
resource "aws_ecr_lifecycle_policy" "custom" {
  policy = jsonencode(
    {
      rules = [
        {
          action = {
            type = "expire"
          }
          description  = "Expire untagged images"
          rulePriority = 1
          selection = {
            countNumber = 7
            countType   = "sinceImagePushed"
            countUnit   = "days"
            tagStatus   = "untagged"
          }
        },
        {
          action = {
            type = "expire"
          }
          description  = "Expire after count reached"
          rulePriority = 2
          selection = {
            countNumber = 25
            countType   = "imageCountMoreThan"
            tagStatus   = "any"
          }
        },
      ]
    }
  )
  repository = aws_ecr_repository.custom.name
}


## Sagemaker-Image
output "sagemaker_image" {
  value = aws_sagemaker_image.custom
}
