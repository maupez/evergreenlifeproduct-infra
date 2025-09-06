# Configure the AWS Provider
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.5"
    }
  }
  backend "s3" {
    bucket      = "evergreenlife-tofu-remote-state"
    key         = "opentofu/states/networking-dev.tfstate"
    region      = var.aws_region
    encrypt     = true
  }
}

# Configure region and profile
provider "aws" {
  region              = "eu-south-1" # var.aws_region
  shared_config_files = ["~/.aws/credentials"]
  profile             = "evergreenlife"
}
