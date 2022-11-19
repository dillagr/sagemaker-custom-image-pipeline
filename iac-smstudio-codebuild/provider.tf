terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
  # backend "local" {}
}

provider "aws" {
  region = var.region
  default_tags {
    tags = {
      project     = "SageMaker"
      environment = "dev"
      department  = "DEPARTMENT"
      costCenter  = "COSTCENTER"
      owner       = "OwnerHere"
      managedBy   = "TerraForm"
    }
  }
}
