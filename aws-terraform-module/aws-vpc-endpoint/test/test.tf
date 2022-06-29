provider "aws" {
  region = "ap-southeast-1"
}

module "as" {
  source = "../"
  vpc_id = "vpc-04fc3b6b0abc327a9"
  tags = {
    "map-migrated" = "d-server-00xwtj6vmucwr9"
  }
  vpc_endpoints = {
    GWM-PRIVATE-NEWENDPOINT-1 = {
      cidr_blocks  = ["10.60.82.128/26"]
      subnet_ids   = ["subnet-076a9ab7a5daf4395", "subnet-0c8b13170675b9431"]
      service_name = "com.amazonaws.ap-southeast-1.execute-api"
    },
    GWM-PRIVATE-NEWENDPOINT-2 = {
      cidr_blocks  = ["10.60.82.128/26"]
      subnet_ids   = ["subnet-076a9ab7a5daf4395", "subnet-0c8b13170675b9431"]
      service_name = "com.amazonaws.ap-southeast-1.execute-api"
    }
  }
}

