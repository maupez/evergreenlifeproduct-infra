data "aws_availability_zones" "available" {}

resource "aws_vpc" "this" {
  cidr_block           = var.cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(var.tags, {
    Name      = "${var.env}-vpc"
    Environment = var.environment
  })
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
  tags = merge(var.tags, {
    Name        = "${var.env}-igw"
    Environment = var.environment
  })
}

resource "aws_eip" "nat" {
  for_each = var.private_subnets
  domain = "vpc"

    tags = {
        Name        = "${var.env}-nat-eip"
        Environment = var.environment
    }
}

resource "aws_nat_gateway" "this" {
  for_each = var.private_subnets

  allocation_id = aws_eip.nat[each.key].id
  subnet_id     = aws_subnet.public[values(var.public_subnets)[0].availability_zone].id
  tags          = { 
    Name = "${var.name}-nat-${each.key}" 
    Environment = var.environment
  }
}

resource "aws_subnet" "public" {
  for_each = var.public_subnets

  vpc_id            = aws_vpc.this.id
  cidr_block        = each.value.cidr_block
  availability_zone = each.value.availability_zone
  map_public_ip_on_launch = true

  tags = { Name = "${var.env}-${var.name}-${each.key}" }
}

resource "aws_subnet" "private" {
  for_each = var.private_subnets

  vpc_id            = aws_vpc.this.id
  cidr_block        = each.value.cidr_block
  availability_zone = each.value.availability_zone

  tags = { Name = "${var.env}-${var.name}-${each.key}" }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id
  tags = merge(var.tags, {
    Name        = "${var.env}-public-rt"
    Environment = var.environment
  })
}

resource "aws_route" "public_internet" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id
}

resource "aws_route_table_association" "public" {
  for_each = var.public_subnets

  subnet_id      = aws_subnet.public[each.key].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private" {
  for_each = var.private_subnets

  vpc_id = aws_vpc.this.id
  tags = merge(var.tags, {
    Name        = "${var.env}-private-rt"
    Environment = var.environment
  })
}

resource "aws_route" "private_nat" {
  for_each = var.private_subnets

  route_table_id         = aws_route_table.private[each.key].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.this[each.key].id
}

resource "aws_route_table_association" "private" {
  for_each = var.private_subnets

  subnet_id      = aws_subnet.private[each.key].id
  route_table_id = aws_route_table.private[each.key].id
}


# resource "aws_vpc" "main" {
#   cidr_block           = var.vpc_cidr_block
#   enable_dns_support   = true
#   enable_dns_hostnames = true

#   tags = merge(var.tags, {
#     Name      = "${var.env}-vpc"
#     Environment = var.environment
#   })
# }

# resource "aws_internet_gateway" "igw" {
#   vpc_id = aws_vpc.main.id

#   tags = merge(var.tags, {
#     Name        = "${var.env}-igw"
#     Environment = var.environment
#   })
# }

# resource "aws_eip" "nat" {
# #   vpc = true
#     domain = "vpc"

#     tags = {
#         Name        = "${var.env}-nat-eip"
#         Environment = var.environment
#     }
# }

# resource "aws_nat_gateway" "nat" {
#   allocation_id = aws_eip.nat.id
#   subnet_id     = aws_subnet.subnets["public-subnet-1"].id

#   tags = merge(var.tags, {
#     Name        = "${var.env}-natgw"
#     Environment = var.environment
#   })
# }

# resource "aws_subnet" "subnets" {
#   for_each = { for subnet in var.subnet_cidr_blocks : subnet.name => subnet }

#   vpc_id                  = aws_vpc.main.id
#   cidr_block              = each.value.cidr_block
#   map_public_ip_on_launch = each.value.public
#   availability_zone       = data.aws_availability_zones.available.names[0]

#   tags = merge(var.tags, {
#     Name        = "${var.env}-${each.value.name}"
#     Environment = var.environment
#   })
# }

# resource "aws_route_table" "public" {
#   vpc_id = aws_vpc.main.id

#   tags = merge(var.tags, {
#     Name        = "${var.env}-public-rt"
#     Environment = var.environment
#   })
# }

# resource "aws_route" "public_internet" {
#   route_table_id         = aws_route_table.public.id
#   destination_cidr_block = "0.0.0.0/0"
#   gateway_id             = aws_internet_gateway.igw.id
# }

# resource "aws_route_table" "private" {
#   vpc_id = aws_vpc.main.id

#   tags = merge(var.tags, {
#     Name        = "${var.env}-private-rt"
#     Environment = var.environment
#   })
# }

# resource "aws_route" "private_nat" {
#   route_table_id         = aws_route_table.private.id
#   destination_cidr_block = "0.0.0.0/0"
#   nat_gateway_id         = aws_nat_gateway.nat.id
# }

# resource "aws_route_table_association" "subnet_associations" {
#   for_each = { for subnet in var.subnet_cidr_blocks : subnet.name => subnet }

#   subnet_id      = aws_subnet.subnets[each.key].id
#   route_table_id = each.value.public ? aws_route_table.public.id : aws_route_table.private.id
# }