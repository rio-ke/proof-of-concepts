## apache2 installation bash script

```bash

#!/usr/bin/env bash

sudo apt-get -y install apache2

sudo systemctl stop nginx

sudo systemctl enable apache2

sudo systemctl status apache2

```

```bash
bash apache2.sh
```

