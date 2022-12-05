github-branch-creation.md

```bash
#!/usr/bin/env bash

SOURCE_BRANCH_NAME="develop"
NEW_BRANCH_NAME="Release/1.7.1"
REPO_NAME="proof-of-concepts"
OWNER_NAME="operation-unknown"
GIT_BEARER_TOKEN="xxxxxx"
SHA=$(curl -s -H "Accept: application/vnd.github+json" -H "Authorization: Bearer ${GIT_BEARER_TOKEN}" "https://api.github.com/repos/${OWNER_NAME}/${REPO_NAME}/branches/${SOURCE_BRANCH_NAME}" | jq .commit.sha)
cat >data.json <<EOF
{
  "ref": "refs/heads/${NEW_BRANCH_NAME}",
  "sha": ${SHA}
}
EOF
cat data.json
curl -s -X POST -H "Accept: application/vnd.github+json" -H "Authorization: Bearer ${GIT_BEARER_TOKEN}" "https://api.github.com/repos/${OWNER_NAME}/${REPO_NAME}/git/refs" -d @data.json | jq .
rm -rf data.json
```
