#### aws-code-commit-credentials.md
---

_.gitconfig modification_

If you wish to gain access to the AWS code commit repository. You must configure these parameters.

```git
# vim .gitconfig
[user]
	email = fourtimes@gmail.com
	name = fourtimes
[init]
	defaultBranch = main
[credential]
	helper = !aws codecommit credential-helper $@
	UseHttpPath = true
```
_configuration_

Configure your AWS credentials so that you can access the code commit repository from your terminal.

```bash

sudo apt update
sudo apt install awscli -y
aws configure

```

_validation_

You can use the appropriate clone URL to clone the AWS code commit repository.
