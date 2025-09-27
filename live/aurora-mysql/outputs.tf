output "aurora_endpoint" {
  value = module.aurora_mysql.endpoint
}

output "aurora_reader_endpoint" {
  value = module.aurora_mysql.reader_endpoint
}


output "data_subnet_ids" {
  value = data.aws_subnets.data.ids
}
