data "azuredevops_project" "ap" {
  name =var.PROJECT_NAME
}

resource "azuredevops_serviceendpoint_azurerm" "asa" {
  project_id            = data.azuredevops_project.ap.id
  service_endpoint_name = var.SERVICE_ENDPOINT_NAME
  description           = "${var.SERVICE_ENDPOINT_NAME} service connection Managed by Terraform"
  credentials {
    serviceprincipalid  = var.AZURE_APP_ID
    serviceprincipalkey = var.AZURE_APP_SECRET
  }
  azurerm_spn_tenantid      =var.TENANT_ID
  azurerm_subscription_id   = var.SUBSCRIPTION_ID
  azurerm_subscription_name = var.SUBSCRIPTION_NAME
}