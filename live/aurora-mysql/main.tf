locals {
  # vpc name 
  vpc_name = "${var.env}-vpc"
  # cidr blocks of the subnets that need access to the database
  be_subnet_cidrs = [
    for subnet in data.aws_subnet.be_cidr_map :
    subnet.value.cidr_block
  ]

}

# retrieve the VPC ID based on the Name tag
data "aws_vpc" "selected" {
  filter {
    name   = "tag:Name"
    values = [local.vpc_name]
  }
}
# retrieve all the subnets ID associated with the selected VPC
data "aws_subnets" "all_subnets" {
  filter {
    name   = local.vpc_name
    values = [data.aws_vpc.selected.id]
  }
}
# retrieve the private subnet ID to be associated with the database
data "aws_subnets" "data" {
  filter {
    name   = "tag:Name"
    values = ["data-subnet"]
  }

  filter {
    name   = local.vpc_name 
    values = [data.aws_vpc.selected.id]
  }
}

# retrieve the subnets IDs that need access to the database
data "aws_subnets" "be" {
  filter {
    name   = "tag:Name"
    values = ["${var.env}-fe-subnet-1", "${var.env}-migration-subnet", "${var.env}-be-subnet-1"]
  }

  filter {
    name   = local.vpc_name
    values = [data.aws_vpc.selected.id]
  }
}
# retrieve the subnets CIDRs that need access to the database
data "aws_subnet" "be_cidr_map" {
  for_each = toset(data.aws_subnets.be.ids)
  id       = each.key
}


# Security Group for Aurora MySQL
module "aurora_sg" {
  source      = "../../modules/security-group"
  name        = "aurora-db-sg"
  description = "Security group for Aurora MySQL cluster"
  vpc_id      = data.aws_vpc.selected.id

  ingress_rules = [
    {
        description = "Allow MySQL from BE servers"
        from_port   = 3306
        to_port     = 3306
        protocol    = "tcp"
        cidr_blocks = local.be_subnet_cidrs
    }
  ]

  egress_rules = [
    {
        description = "Allow all outbound traffic"
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
  ]

  tags = {
    Environment = var.environment
    Project     = var.project
    IaC         = "Created with Terraform/OpenTofu"
  }
}

# Aurora MySQL Cluster
module "aurora_mysql" {
  source              = "../../modules/aurora"
  cluster_identifier  = "${var.env}-${var.cluster_name}-cluster"
  engine_version      = var.engine_version
  instance_class      = var.instance_type
  subnet_ids          = data.aws_subnets.data.ids
  vpc_security_group_ids = [module.aurora_sg.id]
  database_name       = var.database_name
  master_username     = var.master_username
  master_password     = var.master_password
  tags = {
    Environment = var.environment
    Project     = var.project
    IaC         = "Created with Terraform/OpenTofu"
  }
}