**repo-migration from one to another with all files**

_dependencies_

* [git lfs package needs to be installed](
https://docs.github.com/en/repositories/working-with-files/managing-large-files/installing-git-large-file-storage)

```bash
sudo apt install git-lfs
git lfs install
```
_commands_

```bash
sourceGitUsername="sourceGitUsername"
sourceGitPassword="sourceGitPATToken"
targetGitUsername="targetGitUsername"
targetGitPassword="targetGitPATToken"

git clone --bare "https://${sourceGitUsername}:${sourceGitPassword}@github.com/fourtimes/api-automation-testing.git"
cd api-automation-testing.git
git lfs ls-files
git lfs fetch --all
git lfs migrate import --everything --above=100000Kb
git push --mirror "https://${targetGitUsername}:${targetGitPassword}@github.com/operation-unknown/api-automation-testing.git"
git lfs push --all "https://${targetGitUsername}:${targetGitPassword}@github.com/operation-unknown/api-automation-testing.git"
git remote rm origin
git remote add origin "https://${targetGitUsername}:${targetGitPassword}@github.com/operation-unknown/api-automation-testing.git"
git push origin --all --force
```

if any error while cloning the repos

```bash
git config --global http.sslverify false
```
