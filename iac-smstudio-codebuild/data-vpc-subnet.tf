# AWS Account ID
data "aws_caller_identity" "current" {}


## VPC
data "aws_vpc" "selected" {
  tags = {
    ## match this with VPC naming convention
    Name = format("%v-%v-vpc", var.vpc_name, var.environment)
  }
}


## SUBNETS-by-VPC
data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.selected.id]
  }

  # by-tags
  tags = {
    Name = "*private*"
  }
}


# ## SECURITY GROUPS
# data "aws_security_groups" "sg" {
#   filter {
#     name   = "vpc-id"
#     values = [data.aws_vpc.selected.id]
#   }

#   ## by-tags
#   tags = {
#     name = "*private*"
#   }
# }



## Account-ID
output "account" {
  value = data.aws_caller_identity.current
}

## VPC
output "vpc" {
  value = data.aws_vpc.selected
}

## SUBNETS
output "subnets" {
  value = data.aws_subnets.private
}

