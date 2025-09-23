data "aws_security_group" "aurora_sg" {
  name = "${var.env}-aurora-db-sg"
}


module "aurora_mysql" {
  source              = "../../modules/aurora"
  cluster_identifier  = "${var.env}-${var.cluster_name}-cluster"
  engine_version      = var.engine_version
  instance_class      = var.instance_type
  subnet_ids          = var.subnet_ids
  vpc_security_group_ids = [data.aws_security_group.aurora_sg.id]
  database_name       = var.database_name
  master_username     = var.master_username
  master_password     = var.master_password
  tags = {
    Environment = var.environment
    Project     = var.project
    IaC         = "Created with Terraform/OpenTofu"
  }
}