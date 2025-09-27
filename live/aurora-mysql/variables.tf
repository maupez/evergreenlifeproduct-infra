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

variable "cluster_name" {
  description = "The DB cluster identifier"
  type        = string
}

variable "engine_version" {
  description = "The database engine version"
  type        = string
}

variable "instance_type" {
  description = "The instance type of the RDS instances"
  type        = string
  default     = "db.r6g.small"
}

variable "instanceCount" {
  description = "The number of instances in the cluster"
  type        = number
  default     = 1
}

# variable "subnet_ids" {
#   type = list(string)
# }

variable "availability_zones" {
  type = list(string)
}

variable "database_name" {
  description = "The name of the default database to create"
  type        = string
}

variable "master_username" {
  description = "The master username for the database"
  type        = string
  default     = "admin"
}

variable "master_password" {
  type      = string
  sensitive = true
}

variable "sg_ingress_rules" {
  type = list(object({
    description = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = []
}

variable "preferred_backup_window" {
  description = "The daily time range during which automated backups are created if automated backups are enabled"
  type        = string
  default     = "04:00-05:00"
}

variable "performance_insights_enabled" {
  description = "Enable Performance Insights for the RDS instances"
  type        = bool
  default     = false
}
variable "isServerless" {
  description = "Boolean to set the instance type to serverless"
  type        = bool
  default     = true
}