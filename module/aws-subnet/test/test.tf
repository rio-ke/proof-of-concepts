provider "aws" {
  region = "ap-southeast-1"
}


module "as" {
  source = "../"
  vpc_id = "vpc-04fc3b6b0abc327a9"
  tags = {
    "map-migrated" = "d-server-00xwtj6vmucwr9"
  }
  subnets = {
    GWM-APP-AZ1 = {
      availability_zone    = "ap-southeast-1a"
      availability_zone_id = "apse1-az1"
      cidr_block           = "10.60.82.128/26"
      tags = {
        "map-migrated" = "d-server-00xwtj6vmucwr9"
      }
    },
    GWM-APP-AZ2 = {
      vpc_id               = "vpc-04fc3b6b0abc327a9"
      availability_zone    = "ap-southeast-1a"
      availability_zone_id = "apse1-az1"
      cidr_block           = "10.60.82.128/26"
    }
  }
}
