output "instance_id" {
  value       = aws_instance.this.id
  description = "ID of the EC2 instance"
}

output "public_ip" {
  value       = aws_instance.this.public_ip
  description = "Public IP of the EC2 instance"
}

output "private_ip" {
  value       = aws_instance.this.private_ip
  description = "Private IP of the EC2 instance"
}

output "elastic_ip" {
  value       = var.assign_eip ? aws_eip.this[0].public_ip : null
  description = "Elastic IP address if assigned"
}