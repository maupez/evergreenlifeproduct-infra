variable "env" {
  description = "Short name of the environment"
  type        = string

  validation {
    condition     = contains(["dev", "stg", "prd"], var.env)
    error_message = "Invalid value. Allowed values are: dev, stg, prd"
  }
}

variable "environment" {
  description = "Long capitalized name of the environment"
  type        = string

  validation {
    condition     = contains(["Development", "Staging", "Production"], var.environment)
    error_message = "Invalid value. Allowed values are: Development, Staging, Production"
  }
}

variable "vpc_cidr_block" {
  type        = string
  description = "CIDR block for the VPC. Must be /16 or smaller."
  # default = "10.0.0.0/16"

  # validation {
  #   # condition = contains(var.vpc_cidr_block, "/") && can(cidrhost(var.vpc_cidr_block, 0)) && try(tonumber(split(var.vpc_cidr_block, "/")[1]), 0) >= 16
  #   condition = (
  #     strcontains(var.vpc_cidr_block, "/") &&
  #     can(cidrhost(var.vpc_cidr_block, 0)) &&
  #     can(tonumber(split(var.vpc_cidr_block, "/")[1])) &&
  #     tonumber(split(var.vpc_cidr_block, "/")[1]) >= 16 &&
  #     tonumber(split(var.vpc_cidr_block, "/")[1]) <= 24
  #   )
  #   error_message = "VPC CIDR block must be a valid IPv4 CIDR with a /16 or smaller netmask."
  # }
}

variable "subnet_cidr_blocks" {
  type = list(object({
    name        = string
    cidr_block  = string
    public      = bool
    az          = optional(string)
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

variable "tags" {
  type        = map(string)
  description = "Custom tags to apply to all resources"
  default     = {}
}
