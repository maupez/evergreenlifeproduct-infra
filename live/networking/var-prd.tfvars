aws_region  = "eu-south-1"
environment = "Production"
env         = "prd"
project     = "EvergreenLifeProduct"
# Networking
vpc_cidr_block = "172.16.0.0/16"
# subnet-1_cidr_block = "172.16.0.0/24"
# subnet-2_cidr_block = "172.16.1.0/24"
# subnet-3_cidr_block = "172.16.9.0/24"

subnet_cidr_blocks = [
  {
    name       = "fe-subnet-1"
    cidr_block = "172.16.0.0/24"
    public     = true
  },
  {
    name       = "be-subnet-1"
    cidr_block = "172.16.1.0/24"
    public     = false
  },
  {
    name       = "data-subnet-a"
    cidr_block = "172.16.2.0/24"
    public     = false
    az         = "eu-south-1a"
  },
  {
    name       = "data-subnet-b"
    cidr_block = "172.16.3.0/24"
    public     = false
    az         = "eu-south-1b"
  },
  # {
  #   name       = "data-subnet-c"
  #   cidr_block = "172.16.4.0/24"
  #   public     = false
  #   az         = "eu-south-1c"
  # },
  {
    name       = "migration-subnet"
    cidr_block = "172.16.9.0/24"
    public     = true
  },
  {
    name       = "vpn-client-subnet"
    cidr_block = "172.16.200.0/24"
    public     = true
  }
]

allowed_ip_addresses = ["151.31.197.31/31"]