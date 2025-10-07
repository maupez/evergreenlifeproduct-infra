data "aws_ami" "selected" {
  most_recent = false
  owners      = ["self", "amazon", "aws-marketplace"]

  filter {
    name   = "image-id"
    values = [var.ami]
  }
}

data "aws_subnet" "selected" {
  id = var.subnet_id
}

data "aws_route_table" "subnet_route_table" {
  subnet_id = data.aws_subnet.selected.id
}


locals {
  ami_has_root_device = length([
    for bd in data.aws_ami.selected.block_device_mappings :
    bd.device_name if bd.device_name == data.aws_ami.selected.root_device_name
  ]) > 0

  create_root_block_device = var.force_root_block_device ? true : !local.ami_has_root_device

  has_igw_route = length([
    for r in data.aws_route_table.subnet_route_table.route :
    r.gateway_id if r.gateway_id != null && startswith(r.gateway_id, "igw-")        ##################################
  ]) > 0

  eip_tags = merge(
    {
      Name        = "${var.name}-eip"
      Environment = terraform.workspace        ##################################
      ManagedBy   = "Terraform"
    },
    var.eip_tags
  )
}


resource "aws_instance" "this" {
  ami                    = var.ami
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = var.security_group_ids
  key_name               = var.key_name
  iam_instance_profile   = var.iam_instance_profile
  user_data              = var.user_data
  tags                   = merge(var.tags, { Name = var.instance_name })

  dynamic "root_block_device" {
    for_each = local.create_root_block_device ? [1] : []
    content {
      volume_size           = var.root_volume_size
      volume_type           = var.root_volume_type
      delete_on_termination = true
    }

    lifecycle {        ##################################
      precondition {
        condition     = local.create_root_block_device
        error_message = "Root block device creation skipped: AMI already includes one."
      }
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_eip" "this" {
  count    = var.assign_eip ? 1 : 0
  instance = aws_instance.this.id
  vpc      = true        ##################################
  tags     = merge(var.tags, { Name = "${var.instance_name}-eip" })

  lifecycle {
    precondition {
      condition     = local.has_igw_route
      error_message = "Cannot assign Elastic IP: subnet has no route to Internet Gateway."
    }
  }
}


resource "aws_volume_attachment" "existing_ebs" {
  for_each = { for vol_id in var.ebs_volume_ids : vol_id => vol_id }

  device_name = "/dev/sd${substr(each.key, -1, 1)}"
  volume_id   = each.value
  instance_id = aws_instance.this.id

  lifecycle {
    precondition {
      condition     = aws_instance.this.id != ""
      error_message = "Cannot attach volume: EC2 instance not yet created."
    }
  }
}


resource "aws_ebs_volume" "new_volumes" {
  for_each = { for vol in var.create_ebs_volumes : vol.name => vol }

  availability_zone = each.value.availability_zone
  size              = each.value.size
  type              = each.value.type
  encrypted         = each.value.encrypted
  tags              = merge(var.tags, each.value.tags)

  lifecycle {
    precondition {
      condition     = each.value.availability_zone == data.aws_subnet.selected.availability_zone
      error_message = "EBS volume AZ must match subnet AZ for attachment."
    }
  }
}


resource "aws_volume_attachment" "new_attachments" {
  for_each = aws_ebs_volume.new_volumes

  device_name = "/dev/sd${each.value.device_suffix}"
  volume_id   = each.value.id
  instance_id = aws_instance.this.id

  lifecycle {
    precondition {
      condition     = aws_instance.this.id != ""
      error_message = "Cannot attach volume: EC2 instance not yet created."
    }
  }
}

