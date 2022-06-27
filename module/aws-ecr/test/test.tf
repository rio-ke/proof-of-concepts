provider "aws" {
  region = "ap-southeast-1"
}


module "ecr" {
  source = "../"
  tags = {
    ProvisionBy = "Terraform"
  }
  ecr_repositories = {
    gwmclientapp_core = {
      image_tag_mutability = "MUTABLE"
      scan_on_push         = false
    }
    gwmcore_advisormanagmentmoduleapp = {
      image_tag_mutability = "MUTABLE"
    }
  }
}
