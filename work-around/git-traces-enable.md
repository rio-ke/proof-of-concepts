git-traces-enable.md

```bash
export GIT_TRACE_PACKET=1
export GIT_TRACE=1
export GIT_CURL_VERBOSE=1
```

connection closed unexpectly

```bash
git config --global http.postBuffer 157286400
```

Go to your user directory and edit `.git/config` and add

```conf
[core] 
    packedGitLimit = 512m 
    packedGitWindowSize = 512m 
[pack] 
    deltaCacheSize = 2047m 
    packSizeLimit = 2047m 
    windowMemory = 2047m
```
