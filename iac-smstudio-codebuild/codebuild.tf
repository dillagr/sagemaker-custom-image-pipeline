## LOCALS
locals {
  environment_vars = yamldecode(file("etc/environment-vars.yml"))["ENVIRONMENT"]
}


## random integer generator
resource "random_integer" "subnet" {
  min  = 0
  max  = 2
  seed = "Some random number generator"
  keepers = {
    "subnet" = data.aws_caller_identity.current.id
  }
}


resource "aws_codebuild_project" "example" {
  name           = "smstudio-${var.image_name}"
  description    = "SageMaker Studio Codebuild Automation"
  build_timeout  = "15"
  service_role   = aws_iam_role.codebuild.arn
  source_version = "refs/heads/master"

  artifacts {
    type = "NO_ARTIFACTS"
  }

  cache {
    type = "NO_CACHE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_MEDIUM"
    image                       = "aws/codebuild/standard:5.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = true

    dynamic "environment_variable" {
      for_each = local.environment_vars
      content {
        name  = environment_variable.key
        value = environment_variable.value.definition
      }
    }
  }

  logs_config {
    cloudwatch_logs {
      group_name  = "/aws/codebuild/smstudio"
      stream_name = "log-stream-${var.image_name}"
    }

    s3_logs {
      status = "DISABLED"
    }
  }

  source {
    type                = "CODECOMMIT"
    location            = aws_codecommit_repository.repo.clone_url_http
    git_clone_depth     = 1
    report_build_status = false
    insecure_ssl        = false

    git_submodules_config {
      fetch_submodules = false
    }
  }

  ## change accordingly
  vpc_config {
    vpc_id             = data.aws_vpc.selected.id
    subnets            = [data.aws_subnets.private.ids][random_integer.subnet.result] ## this is one subnet only, selected by random_integer
    # security_group_ids = [aws_security_group.codebuild.id]                          ## this is list of security groups
    security_group_ids = [ "sg-0f468fb6d3bd2a7dc" ]                                   ## already created, no need to re-create
  }


  tags = {
    Name = "smstudio-${var.image_name}"
  }

  depends_on = [
    aws_codecommit_repository.repo
  ]
}

