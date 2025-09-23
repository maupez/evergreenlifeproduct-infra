variable "cluster_identifier" {
  type = string
}

variable "engine_version" {
  type    = string
  default = "8.0.mysql_aurora.3.04.0"
}

variable "instance_class" {
  type    = string
  default = "db.r6g.large"
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

variable "tags" {
  type    = map(string)
  default = {}
}