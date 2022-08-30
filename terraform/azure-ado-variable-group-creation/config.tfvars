devOpsProjectName="project name"        # existing project name you should pass
variableGroupName="variable group name" # create the new group with some secrets
secrets = [
  {
    name         = "disk0",
    secret_value = "30",
    is_secret    = true,
  },
  {
    name         = "disk1",
    secret_value = "30",
    is_secret    = false
}]
