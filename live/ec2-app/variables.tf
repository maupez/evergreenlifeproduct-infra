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

  validation {
    condition     = contains(["Development", "Staging", "Production"], var.environment)
    error_message = "Invalid value. Allowed values are: Development, Staging, Production"
  }
}

variable "env" {
  description = "Short name of the environment"
  type        = string

  validation {
    condition     = contains(["dev", "stg", "prd"], var.env)
    error_message = "Invalid value. Allowed values are: dev, stg, prd"
  }
}

variable "my-key" {
  type        = string
  default     = "red-key"
  description = "SSH key name to use for EC2 instances"
}

variable "ami_id" {
  type        = string
  description = "AMI ID for the application instance"

}

variable "instance_type" {
  type        = string
  description = "Instance type for the application server"
}

variable "subnet_id" {
  type        = string
  description = "Subnet ID for the application instance"
}

variable "security_group_ids" {
  type        = list(string)
  description = "Security Group IDs for the application instance"
}

variable "user_data" {
  type        = string
  default     = ""
  description = "User data script for the application instance"
}

variable "force_root_block_device" {
  type        = bool
  default     = false
  description = "Force root block device creation for instance"
}

variable "assign_eip" {
  type        = bool
  default     = false
  description = "Whether to assign an Elastic IP to the instance"
}

variable "create_ebs_volumes" {
  type = list(object({
    name              = string
    availability_zone = string
    size              = number
    type              = string
    encrypted         = bool
    device_suffix     = string
    tags              = map(string)
  }))
  default     = []
  description = "List of new EBS volumes to create and attach to the instance"
}

variable "tags" {
  type = map(string)
  default = {}
}

