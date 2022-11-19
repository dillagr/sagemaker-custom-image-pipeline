## REQD-BY: CODEBUILD
resource "aws_codecommit_repository" "repo" {
  repository_name = "smstudio-${var.image_name}"
  description     = "Some Repository created by Terraform Automation"
}


## CodeCommit
output "codecommit_repo" {
  value = aws_codecommit_repository.repo
}
