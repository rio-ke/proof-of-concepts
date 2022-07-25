## current-login-notification

```bash
vim current-login-notification
```

```bash

#!/usr/bin/env bash

notify-send -t 3000 "User logged in" `whoami`

```
