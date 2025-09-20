aws_region = "eu-south-1"
environment = "Production"
env = "prd"
project = "EvergreenLifeProduct"
# Networking
vpc_cidr_block = "172.16.0.0/16"
vpc2_cidr_block = "10.0.0.0/16"
# subnet-1_cidr_block = "172.16.0.0/24"
# subnet-2_cidr_block = "172.16.1.0/24"
# subnet-3_cidr_block = "172.16.9.0/24"
fe_cidr_block = "10.0.0.0/24"
be_cidr_block = "10.0.1.0/24"
db_cidr_block = "10.0.2.0/24"
vpn_cidr_block = "10.0.3.0/24"

# subnet_cidr_blocks = [
#     {
#       name       = "public-subnet-1"
#       cidr_block = "172.16.0.0/24"
#       public     = true
#     },
#     {
#       name       = "private-subnet-1"
#       cidr_block = "172.16.1.0/24"
#       public     = false
#     },
#     {
#       name       = "migration-subnet"
#       cidr_block = "172.16.9.0/24"
#       public     = true
#     }
# ]

vpc_definitions = {
  "vpc-migration" = {
    cidr_block = "172.16.0.0/16"
    public_subnets = {
      "public-a" = {
        cidr_block        = "172.16.0.0/24"
        availability_zone = "eu-south-1a"
      },
      "public-migration" = {
        cidr_block        = "172.16.9.0/24"
        availability_zone = "eu-south-1b"
      }
    }
    private_subnets = {
      "private-a" = {
        cidr_block        = "172.16.1.0/24"
        availability_zone = "eu-south-1a"
      # },
      # "private-b" = {
      #   cidr_block        = "10.0.102.0/24"
      #   availability_zone = "eu-south-1b"
      # }
    }
  },
  "vpc-prd" = {
    cidr_block = "10.0.0.0/16"
    public_subnets = {
      "public-a" = {
        cidr_block        = "10.0.1.0/24"
        availability_zone = "eu-south-1a"
      },
      "public-b" = {
        cidr_block        = "10.0.2.0/24"
        availability_zone = "eu-south-1b"
      }
    }
    private_subnets = {
      "private-a" = {
        cidr_block        = "10.0.101.0/24"
        availability_zone = "eu-south-1a"
      },
      "private-b" = {
        cidr_block        = "10.0.102.0/24"
        availability_zone = "eu-south-1b"
      }
    }
  },

}

