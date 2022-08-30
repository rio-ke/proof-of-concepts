terraform {
  required_providers {
    azuredevops = {
      source  = "microsoft/azuredevops"
      version = ">=0.1.0"
    }
  }
}


data "azuredevops_project" "adp" {
  name = var.devOpsProjectName
}


resource "azuredevops_variable_group" "example" {
  project_id   = data.azuredevops_project.adp.id
  name         = var.variableGroupName
  description  = var.variableGroupName
  allow_access = true

  variable {
    name         = "key2"
    secret_value = "val2"
    is_secret    = true
  }


  dynamic "variable" {
    for_each = var.secrets == null ? [] : [true]
    content {
      name         = lookup(var.secrets, "secretName")
      secret_value = lookup(var.secrets, "secretValue")
      is_secret    = lookup(var.secrets, "hideSecret")
    }
  }
}


variable "devOpsProjectName" {
  default = "Nexus for Banking"
}

variable "variableGroupName" {
    default = "demo"
}



variable "secrets" {
  type = any
  # default = null
  default = [
    {
      secretName  = "keyname2"
      secretValue = "keyvalue2"
      hideSecret  = true
    },
    {
      secretName  = "keyname1"
      secretValue = "keyvalue1"
      is_secret   = false
    }
  ]
}

# https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/guides/authenticating_using_the_personal_access_token
