output "vpc_id" {
  value       = aws_vpc.main.id
  description = "The ID of the created VPC"
}

output "subnet_ids" {
  value       = { for k, s in aws_subnet.subnets : k => s.id }
  description = "Map of subnet names to their IDs"
}

output "internet_gateway_id" {
  value       = aws_internet_gateway.igw.id
  description = "ID of the Internet Gateway"
}

output "nat_gateway_id" {
  value       = aws_nat_gateway.nat.id
  description = "ID of the NAT Gateway"
}