github-branch-creation.md

```bash
#!/usr/bin/env bash

APP_NAME=$(awk -F '<[^>]*>' '/<dependencies>/,/<\/dependencies>/{next} /artifactId/{$1=$1;print $0}' pom.xml)
echo "Application name is ${APP_NAME}"
# VERSION=$(awk -F '<[^>]*>' '/<dependencies>/,/<\/dependencies>/{next} /version/{$1=$1;print$0}' pom.xml | xargs | awk -F - '{print $1}')


VERSION=$(grep version pom.xml | grep -v -e '<?xml|~'| grep -i snapshot | sed 's/[[:space:]]//g' | sed -E 's/<.{0,1}version>//g' | awk '{print $1}' | xargs | awk -F - '{print $1}')
echo "Current version is ${VERSION}"
SOURCE_BRANCH_NAME="develop"
NEW_BRANCH_NAME="${VERSION}"
REPO_NAME="proof-of-concepts"
OWNER_NAME="operation-unknown"
GIT_BEARER_TOKEN="xxxxxx"
SHA=$(curl -s -H "Accept: application/vnd.github+json" -H "Authorization: Bearer ${GIT_BEARER_TOKEN}" "https://api.github.com/repos/${OWNER_NAME}/${REPO_NAME}/branches/${SOURCE_BRANCH_NAME}" | jq .commit.sha)

cat >data.json <<EOF
{
  "ref": "refs/heads/Release/${NEW_BRANCH_NAME}",
  "sha": ${SHA}
}
EOF
cat data.json
curl -s -X POST -H "Accept: application/vnd.github+json" -H "Authorization: Bearer ${GIT_BEARER_TOKEN}" "https://api.github.com/repos/${OWNER_NAME}/${REPO_NAME}/git/refs" -d @data.json | jq .
rm -rf data.json
```
