module "networking" {
  environment    = var.environment 
  env            = var.env
  source         = "../../modules/networking"
  vpc_cidr_block = var.vpc_cidr_block
  subnet_cidr_blocks = var.subnet_cidr_blocks

  tags = {
    Environment = var.environment
    Project     = var.project
    IaC         = "Created with Terraform/OpenTofu"
  }
}