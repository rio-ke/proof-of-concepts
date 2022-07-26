
```bash
#!/usr/bin/env bash

# current-active-user.sh
who | awk -F: '{ print $1 }'
```
