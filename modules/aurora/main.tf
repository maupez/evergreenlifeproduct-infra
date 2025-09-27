resource "aws_rds_cluster" "aurora" {
  cluster_identifier      = var.cluster_identifier
  engine                  = "aurora-mysql"
  engine_version          = var.engine_version
  availability_zones      = var.availability_zones
  database_name           = var.database_name
  master_username         = var.master_username
  master_password         = var.master_password
  db_subnet_group_name    = aws_db_subnet_group.aurora.name
  vpc_security_group_ids  = var.vpc_security_group_ids
  skip_final_snapshot     = true
  tags                    = var.tags
  backup_retention_period = var.backup_retention_period
  preferred_backup_window = var.preferred_backup_window
}

resource "aws_rds_cluster_instance" "aurora_instances" {
  count                   = var.instanceCount
  identifier              = "${var.cluster_identifier}-instance-${count.index}"
  cluster_identifier      = aws_rds_cluster.aurora.id
  instance_class          = var.instance_class
  engine                  = aws_rds_cluster.aurora.engine
  engine_version          = aws_rds_cluster.aurora.engine_version
  db_subnet_group_name    = aws_db_subnet_group.aurora.name
  publicly_accessible     = false
  tags                    = var.tags
}

resource "aws_db_subnet_group" "aurora" {
  name       = "${var.cluster_identifier}-subnet-group"
  subnet_ids = var.subnet_ids
  tags       = var.tags
}
