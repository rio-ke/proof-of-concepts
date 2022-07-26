## apache2 installation bash script

```bash

#!/usr/bin/env bash

set -x

sudo systemctl stop nginx

sudo apt-get -y install apache2

sudo systemctl enable apache2

sudo systemctl status apache2

```

**_bash script execution command_**

```bash
bash apache2.sh
```

