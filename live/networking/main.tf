# module "networking" {
#   environment    = var.environment 
#   env            = var.env
#   source         = "../../modules/networking"
#   vpc_cidr_block = var.vpc_cidr_block

#   # subnet_cidr_blocks = [
#   #   {
#   #     name       = "public-subnet-1"
#   #     cidr_block = var.subnet-1_cidr_block
#   #     public     = true
#   #   },
#   #   {
#   #     name       = "private-subnet-1"
#   #     cidr_block = var.subnet-2_cidr_block
#   #     public     = false
#   #   },
#   #   {
#   #     name       = "migration-subnet"
#   #     cidr_block = var.subnet-3_cidr_block
#   #     public     = true
#   #   },
#   #   {
#   #     name       = "frontend-subnet"
#   #     cidr_block = var.frontend_cidr_block
#   #     public     = true
#   #   },
#   # ]
#   subnet_cidr_blocks = var.subnet_cidr_blocks

#   tags = {
#     Environment = var.environment
#     Project     = var.project
#     IaC         = "Created with Terraform/OpenTofu"
#   }
# }


module "vpc" {
  source = "../modules/networking"
  for_each = var.vpc_definitions

  name            = each.key
  cidr_block      = each.value.cidr_block
  public_subnets  = each.value.public_subnets
  private_subnets = each.value.private_subnets
}
