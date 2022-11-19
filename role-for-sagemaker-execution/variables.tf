variable "managedBy" {
  type    = string
  default = "TerraForm"
}

variable "region" {
  description = "Target AWS Region to apply this configuration"
  default     = "us-east-2"
  type        = string
}

variable "project" {
  description = "Project Name"
  type        = string
  default     = "sagemaker"
}

variable "purpose" {
  description = "Purpose (Not Project Name, but related)"
  type        = string
  default     = "main"
}

variable "vpc_name" { default = "aiml" }

variable "environment" { default = "dev" }

//Resources
#variable "image_name" { type = string }
