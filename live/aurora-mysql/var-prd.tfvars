aws_region  = "eu-south-1"
environment = "Production"
env         = "prd"
project     = "EvergreenLifeProduct"

# Aurora MySQL
isServerless       = false
cluster_name       = "evergreenlifeproduct"
# availability_zones = ["eu-south-1a", "eu-south-1b", "eu-south-1c"]
availability_zones = ["eu-south-1a", "eu-south-1b"]
engine_version     = "5.7.mysql_aurora.2.11.5"
instance_type      = "db.r5.large"
master_username         = "admin"
master_password         = "WedQNznrdLx6OOD"
database_name           = "evergreenlifeproduct"
preferred_backup_window = "04:00-05:00"
performance_insights_enabled = true
