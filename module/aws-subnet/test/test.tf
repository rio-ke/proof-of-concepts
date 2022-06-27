provider "aws" {
  region = "ap-southeast-1"
}


module "as" {
  source = "../module/aws-subnet"
  subnets = {
    GWM-APP-AZ1 = {
      vpc_id                                         = "vpc-04fc3b6b0abc327a9"
      assign_ipv6_address_on_creation                = false
      availability_zone                              = "ap-southeast-1a"
      availability_zone_id                           = "apse1-az1"
      cidr_block                                     = "10.60.82.128/26"
      enable_dns64                                   = false
      enable_resource_name_dns_a_record_on_launch    = false
      enable_resource_name_dns_aaaa_record_on_launch = false
      ipv6_native                                    = false
      map_customer_owned_ip_on_launch                = false
      map_public_ip_on_launch                        = false
      tags = {
        "Name"         = "GWM-APP-AZ1"
        "map-migrated" = "d-server-00xwtj6vmucwr9"
      }
    }

  }
}
