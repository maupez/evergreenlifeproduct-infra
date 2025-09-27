variable "cluster_identifier" {
  type = string
}

variable "instanceCount" {
  type    = number
  default = 1
}

variable "engine_version" {
  type    = string
  default = "8.0.mysql_aurora.3.04.0"
}

variable "availability_zones" {
  type = list(string)
}

variable "backup_retention_period" {
  type    = number
  default = 1
}

variable "instance_class" {
  type    = string
  default = "db.serverless"
}

variable "subnet_ids" {
  type = list(string)
}

variable "vpc_security_group_ids" {
  type = list(string)
}

variable "database_name" {
  type = string
}

variable "master_username" {
  type = string
}

variable "master_password" {
  type      = string
  sensitive = true
}

variable "preferred_backup_window" {
  description = "The daily time range during which automated backups are created if automated backups are enabled"
  type        = string
}

variable "performance_insights_enabled" {
  type    = bool
  default = false
}

variable "tags" {
  type    = map(string)
  default = {}
}