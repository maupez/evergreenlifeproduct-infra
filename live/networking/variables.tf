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

variable "subnet_cidr_blocks" {
  type = list(object({
    name       = string
    cidr_block = string
    public     = bool
    az         = optional(string)
  }))
  description = "List of subnet definitions with name, CIDR block, public flag, and environment tag."

  # validation {
  #   condition = alltrue([
  #     for subnet in var.subnet_cidr_blocks : (
  #       can(cidrhost(subnet.cidr_block, 0)) &&
  #       # tonumber(split(subnet.cidr_block, "/")[1]) >= 24 &&
  #       cidrcontains(var.vpc_cidr_block, cidrhost(subnet.cidr_block, 0))
  #     )
  #   ])
  #   error_message = "Each subnet must be a valid IPv4 CIDR with a /24 or smaller netmask and must be inside the VPC block."
  # }
}

variable "allowed_ip_addresses" {
  description = "List of allowed IP addresses or CIDR blocks for SSH access"
  type        = list(string)
  default     = []
}