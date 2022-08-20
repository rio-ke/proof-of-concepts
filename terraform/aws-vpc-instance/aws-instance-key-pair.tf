resource "aws_key_pair" "akp" {
  key_name   = "${var.PROJECT}-${var.ENVIRONMENT}-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCntw9fawCfpZ0nfWuu7HZlkrdKPyR6Dx6Pqn/oPqXUuDNvIGRl83wFsMAWikk6p0DWbOripLRpxUzLZIyzoySQm2M0m6wqWSUzj1jzcd1fYcWYClwABuER6Qn9poX/p+ZBRXKIlV4gK9NL65/dGdQXZcKR9KpfQzpLyQaWraFVGvNycKN7g7BAmc5NeA0315bf25WWQ+yWwE449Hz8ld6TqQvM029M1QYhLNvfz0im3s1QFUXsO8JOHbSCAUOzQX2HliI0lkN04jEZkFG7VvEuXDdj6VJcbCt6NedXEjuReh/nawJodpTDQPlwU6nnH+K8+mykGnFfxXEI2zkx0Fko338hazD/xViY5t3ere6f6oyz94vW88Rg8B2/89+2Si4OPxpY7eXu63aKasx2KLDiXEFUWd9AgBf2+PMwhVq1qcrbjHyGrdYSf68K8o6fmp0TonxOdNZN0TVzFsL1Iufms0WrrR8cnk4uTVyP3mkf1fB3Ax/XVLADYgPJxlB5Oc8= dodo@xps-13-9360"
  depends_on = [
    aws_vpc.av
  ]
}
