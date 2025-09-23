# evergreenlifeproduct-infra

# List of resources

- Networking:
  
  internet_gateway_id = "igw-02fdaf22a321e0d4f"

  nat_gateway_id = "nat-0c845744ac55d70e6"

  subnet_ids = {

    "fe-subnet-1" = "subnet-0ade20a2e15d4dc48" (NATGW, +ALB, +SERVER VPN, +POWERBI?)
  
    "migration-subnet" = "subnet-0dab4967017a956e8" (EC2 MIGRATION RESOURCES & VMs)
  
    "be-subnet-1" = "subnet-075832e49941e5d28" (BE: +eWallet, +FileSystem, +FE_se_ALB, +POWERBI_se_connessione_via_vpn?)
  
    "data-subnet" = "subnet-056ed236fde0bbb6b" (DATA: +AuroraMySQL, +POWERBI_se_connessione_via_vpn)
  
    "vpn-client-subnet" = "subnet-0f26e9e7be69c856f" (VPN CLIENT SERVER per migrazione db)
  
  }

  vpc_id = "vpc-050930db19799d22d"
