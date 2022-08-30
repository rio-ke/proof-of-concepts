data "azuredevops_project" "adp" {
  name = var.devOpsProjectName
}

resource "azuredevops_variable_group" "example" {
  project_id   = data.azuredevops_project.adp.id
  name         = var.variableGroupName
  description  = var.variableGroupName
  allow_access = true

  dynamic "variable" {
    for_each = local.variables
    content {
      name         = variable.value.name
      secret_value = variable.value.secret_value
      is_secret    = variable.value.is_secret
    }
  }
}


locals {
  variables = var.secrets
}

variable "devOpsProjectName" {
  default = "Nexus for Banking"
}

variable "variableGroupName" {
  default = "demo"
}

variable "secrets" {
  type    = any
  default = null
}
