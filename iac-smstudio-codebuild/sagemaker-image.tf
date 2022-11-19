## IMAGE
resource "aws_sagemaker_image" "custom" {
  image_name = "smstudio-${var.image_name}"
  role_arn   = aws_iam_role.codebuild.arn
}


## ECR-REPOSITORY
resource "aws_ecr_repository" "custom" {
  name = "smstudio-${var.image_name}"

  image_scanning_configuration {
     scan_on_push = true
  }
}


## Sagemaker-Image
output "sagemaker_image" {
  value = aws_sagemaker_image.custom
}
