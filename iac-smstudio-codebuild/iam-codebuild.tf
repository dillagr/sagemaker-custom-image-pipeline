locals {
  codebuild_policy_file = yamldecode(file("etc/template-policies.yml"))["CODEBUILD"]
}

locals {
  codebuild_policies = flatten([
    for service_key, service_val in local.codebuild_policy_file : [
      for rule in service_val.source-file : {
        policy_name = service_key
        filename    = rule.filename
      }
    ]
  ])
}


# template-files
data "template_file" "codebuild" {
  for_each = { for v in local.codebuild_policies : "${v.filename}" => v }
  template = file("src/${each.value.filename}")
  vars = {
    TEMPLATE_AWS_REGION    = var.region
    TEMPLATE_AWS_ACCOUNTID = data.aws_caller_identity.current.account_id
    TEMPLATE_IMAGE_NAME    = var.image_name
  }
}


#------ CODEBUILD-EXEC-ROLE----------------------------------------------
# aws_iam_role.codebuild:
resource "aws_iam_role" "codebuild" {
  assume_role_policy = jsonencode(
    {
      Statement = [
        {
          Action = "sts:AssumeRole"
          Effect = "Allow"
          Principal = {
            Service = [
              "codebuild.amazonaws.com",
              "sagemaker.amazonaws.com"
            ]
          }
        },
      ]
      Version = "2012-10-17"
    }
  )

  description          = "Role for SageMakerStudio CodeBuild"
  max_session_duration = 14400
  name                 = "role-for-codebuild-${var.image_name}"

}


# aws_iam_role_policy.policy:
resource "aws_iam_role_policy" "codebuild" {
  for_each = { for v in local.codebuild_policies : "${v.filename}" => v }
  name     = "${each.value.policy_name}-${var.image_name}-policy"
  policy   = data.template_file.codebuild[each.value.filename].rendered
  role     = aws_iam_role.codebuild.id
}



#------ AWS-MANAGED-POLICIES ----------------------------------------------
locals {
  codebuild_vars = yamldecode(file("etc/aws-managed-policies.yml"))["CODEBUILD"]
}

## SageMakerFullAccess, etc
resource "aws_iam_role_policy_attachment" "codebuild" {
  for_each   = local.codebuild_vars
  role       = aws_iam_role.codebuild.id
  policy_arn = "arn:aws:iam::aws:policy/${each.value.definition}"
}




#------ OUTPUTS ----------------------------------------------
## Role
output "codebuild_role" {
  value = aws_iam_role.codebuild
}

## Policy 
output "codebuild_policy" {
  value = aws_iam_role_policy.codebuild
}