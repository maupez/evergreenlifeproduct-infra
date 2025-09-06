variable "aws_region" {
  description = "AWS region where the resources will be provisioned"
  type        = string
  default     = "eu-south-1"
}

variable "project" {
  description = "Name of the project"
  type        = string
  default     = "EvergreenLifeProduct"
}

variable "environment" {
  description = "Long capitalized name of the environment"
  type        = string
  # default     = "Development"

  validation {
    condition     = contains(["Development", "Staging", "Production"], var.environment)
    error_message = "Invalid value. Allowed values are: Development, Staging, Production"
  }
}

variable "env" {
  description = "Short name of the environment"
  type        = string
  # default     = "dev"

  validation {
    condition     = contains(["dev", "stg", "prd"], var.env)
    error_message = "Invalid value. Allowed values are: dev, stg, prd"
  }
}

variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
  # default     = "10.0.0.0/16"

  validation {
    condition     = can(cidrhost(var.vpc_cidr_block, 0))
    error_message = "Invalid value. The value must be a valid IPv4 CIDR block, like 10.0.0.0/16"
  }
}

variable "subnet-1_cidr_block" {
  description = "CIDR block for the first subnet"
  type        = string
  # default     = "10.0.0.0/24"

  validation {
    condition     = can(cidrhost(var.subnet-1_cidr_block, 0))
    error_message = "Invalid value. The value must be a valid IPv4 CIDR block, like 10.0.0.0/24"
  }
}

variable "subnet-2_cidr_block" {
  description = "CIDR block for the second subnet"
  type        = string
  # default     = "10.0.0.0/24"

  validation {
    condition     = can(cidrhost(var.subnet-2_cidr_block, 0))
    error_message = "Invalid value. The value must be a valid IPv4 CIDR block, like 10.0.0.0/24"
  }
}