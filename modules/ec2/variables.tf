variable "instance_name" {
  description = "Name tag for the EC2 instance"
  type        = string
}

variable "ami" {
  description = "AMI ID for the EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "Instance type for the EC2 instance"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID where the EC2 instance will be launched"
  type        = string
}

variable "security_group_ids" {
  description = "List of Security Group IDs to associate with the EC2 instance"
  type        = list(string)
}

variable "key_name" {
  description = "Key pair name for SSH access"
  type        = string
  default     = null
}

variable "iam_instance_profile" {
  description = "IAM instance profile to associate with the EC2 instance"
  type        = string
  default     = null
}

variable "user_data" {
  description = "User data scxript to configure the EC2 instance"
  type        = string
  default     = null
}

variable "root_volume_size" {
  description = "Size of the root EBS volume in GB"
  type        = number
  default     = 8
}

variable "root_volume_type" {
  description = "Type of the root EBS volume"
  type        = string
  default     = "gp3"
}

variable "force_root_block_device" {
  type        = bool
  default     = false
  description = "Force creation of root block device even if AMI has one"
}

variable "ebs_volume_ids" {
  type        = list(string)
  default     = []
  description = "List of existing EBS volume IDs to attach"
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
  description = "List of new EBS volumes to create and attach"
}

variable "assign_eip" {
  type        = bool
  default     = false
  description = "Whether to create and associate an Elastic IP"
}



variable "tags" {
  type = map(string)
  default = {}
}