output "vpc_id" {
  value = module.networking.vpc_id
}

output "subnet_ids" {
  value = module.networking.subnet_ids
}

output "internet_gateway_id" {
  value = module.networking.internet_gateway_id
}

output "nat_gateway_id" {
  value = module.networking.nat_gateway_id
}