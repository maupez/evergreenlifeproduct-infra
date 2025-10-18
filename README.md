# evergreenlifeproduct-infra

# Source Instances
MariaDB - red.mariadb-evergree-3-aws - 172.16.9.13 - c5.2xlarge

Server Web - red-app-evergreen-aws 172.16.9.59 - c5.xlarge

eWallet - red-app2-evergreen-aws 172.16.9.17 - c5.large

FileSystem - red-fs-evergreen-aws 172.16.9.25 - c5.large

PowerBI (win) - red-bi-evergreen-aws 172.16.9.16


# List of resources

- Networking:

  vpc_id = "vpc-050930db19799d22d"
  
  internet_gateway_id = "igw-02fdaf22a321e0d4f"

  nat_gateway_id = "nat-0c845744ac55d70e6"

  subnet_ids = {

    "fe-subnet-1" = "subnet-0ade20a2e15d4dc48" (NATGW, +ALB, +SERVER VPN, +POWERBI?)

    "fe-subnet-b" = "subnet-0e124db20dcd926a5" (+ALB)
  
    "migration-subnet" = "subnet-0dab4967017a956e8" (EC2 MIGRATION RESOURCES & VMs)
  
    "be-subnet-1" = "subnet-075832e49941e5d28" (BE: +eWallet, +FileSystem, +FE_se_ALB, +POWERBI_se_connessione_via_vpn?)
  
    "data-subnet-a" = "subnet-00ae8a256718648db" (DATA: +AuroraMySQL, +POWERBI_se_connessione_via_vpn)

    "data-subnet-b" = "subnet-07ad8a661fc359cdf" (DATA: +AuroraMySQL)
  
    "vpn-client-subnet" = "subnet-0f26e9e7be69c856f" (VPN CLIENT SERVER per migrazione db)
  
  }

- Database:

  aurora_endpoint = "prd-evergreenlifeproduct-cluster.cluster-c9cwmoyw6zhe.eu-south-1.rds.amazonaws.com"
  
  aurora_reader_endpoint = "prd-evergreenlifeproduct-cluster.cluster-ro-c9cwmoyw6zhe.eu-south-1.rds.amazonaws.com"
  
  data_subnet_ids = tolist([
    
    "subnet-07ad8a661fc359cdf",
    
    "subnet-00ae8a256718648db",

  ])
