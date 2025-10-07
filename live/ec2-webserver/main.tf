module "app" {
  source              = "../../modules/ec2-instance"
  name                = "${var.env}-app"
  ami                 = var.ami_id
  instance_type       = var.instance_type
  subnet_id           = var.subnet_id
  security_group_ids  = var.security_group_ids
  key_name            = var.key_name
  user_data           = var.user_data
  force_root_block_device = var.force_root_block_device
  assign_eip          = var.assign_eip
}
