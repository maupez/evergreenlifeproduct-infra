data "aws_availability_zones" "available" {}

resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(var.tags, {
    Name      = "${var.env}-vpc"
    Environment = var.environment
  })
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = merge(var.tags, {
    Name        = "${var.env}-igw"
    Environment = var.environment
  })
}

resource "aws_eip" "nat" {
#   vpc = true
    domain = "vpc"

    tags = {
        Name        = "${var.env}-nat-eip"
        Environment = var.environment
    }
}

resource "aws_nat_gateway" "nat" {
  depends_on = [ aws_subnet.subnets ]

  allocation_id = aws_eip.nat.id
  # Create the NAT Gateway only in the first public subnet defined
  subnet_id     = aws_subnet.subnets[[for subnet in var.subnet_cidr_blocks : subnet.name if subnet.public][0]].id

  tags = merge(var.tags, {
    Name        = "${var.env}-natgw"
    Environment = var.environment
  })
}

resource "aws_subnet" "subnets" {
  for_each = { for subnet in var.subnet_cidr_blocks : subnet.name => subnet }

  vpc_id                  = aws_vpc.main.id
  cidr_block              = each.value.cidr_block
  map_public_ip_on_launch = each.value.public
  availability_zone       = each.value.az != null ? each.value.az : data.aws_availability_zones.available.names[0]
  tags = merge(var.tags, {
    Name        = "${var.env}-${each.value.name}"
    Environment = var.environment
  })
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = merge(var.tags, {
    Name        = "${var.env}-public-rt"
    Environment = var.environment
  })
}

resource "aws_route" "public_internet" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  tags = merge(var.tags, {
    Name        = "${var.env}-private-rt"
    Environment = var.environment
  })
}

resource "aws_route" "private_nat" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id
}

resource "aws_route_table_association" "subnet_associations" {
  for_each = { for subnet in var.subnet_cidr_blocks : subnet.name => subnet }

  subnet_id      = aws_subnet.subnets[each.key].id
  route_table_id = each.value.public ? aws_route_table.public.id : aws_route_table.private.id
}