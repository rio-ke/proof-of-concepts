```yml
---
name: to find the github trigger branch name
on: [push]
jobs:
  branch:
    runs-on: ubuntu-latest
    steps:
      - name: Branch Name
        shell: bash
        run: echo "##[set-output name=branch;]$(echo ${GITHUB_REF#refs/heads/})"
        id: branch_name
    outputs:
      branch: ${{ steps.branch_name.outputs.branch }}
  print-branch-details:
    needs: 
    - branch
    runs-on: ubuntu-latest
    steps: 
      - name: Print
        run: echo ${{ needs.ids.outputs.branch }
 ```
