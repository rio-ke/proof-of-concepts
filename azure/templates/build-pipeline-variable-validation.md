```yml
---
parameters:
  PERFORM_CHECKMARX: false
  PERFORM_DOCKER_PUSH: false
  PERFORM_UNIT_TEST_WITH_COVERAGE: false
  PERFORM_BUILD_BREAKER: false
  PERFORM_AQUA: false
  PERFORM_DOCKER_BUILD: false
steps:
  - script: |
      [[ ! -z "${PERFORM_CHECKMARX}" ]]       && echo "##vso[task.setvariable variable=PERFORM_CHECKMARX]${PERFORM_CHECKMARX}" || exit 1
      [[ ! -z "${PERFORM_DOCKER_PUSH}" ]]     && echo "##vso[task.setvariable variable=PERFORM_DOCKER_PUSH]${PERFORM_DOCKER_PUSH}" || exit 1
      [[ ! -z "${PERFORM_DOCKER_BUILD}" ]]    && echo "##vso[task.setvariable variable=PERFORM_DOCKER_BUILD]${PERFORM_DOCKER_BUILD}" || exit 1
      [[ ! -z "${PERFORM_BUILD_BREAKER}" ]]   && echo "##vso[task.setvariable variable=PERFORM_BUILD_BREAKER]${PERFORM_BUILD_BREAKER}" || exit 1
      [[ ! -z "${PERFORM_AQUA}" ]]            && echo "##vso[task.setvariable variable=PERFORM_AQUA]${PERFORM_AQUA}" || exit 1
      [[ ! -z "${PERFORM_UNIT_TEST_WITH_COVERAGE}" ]]  && echo "##vso[task.setvariable variable=PERFORM_UNIT_TEST_WITH_COVERAGE]${PERFORM_UNIT_TEST_WITH_COVERAGE}" || exit 1
    displayName: CONDITION task selection process
    env:
      PERFORM_CHECKMARX: '${{ parameters.PERFORM_CHECKMARX }}'
      PERFORM_DOCKER_PUSH: '${{ parameters.PERFORM_DOCKER_PUSH }}'
      PERFORM_DOCKER_BUILD: '${{ parameters.PERFORM_DOCKER_BUILD }}'
      PERFORM_BUILD_BREAKER: '${{ parameters.PERFORM_BUILD_BREAKER }}'
      PERFORM_AQUA: '${{ parameters.PERFORM_AQUA }}'
      PERFORM_UNIT_TEST_WITH_COVERAGE: '${{ parameters.PERFORM_UNIT_TEST_WITH_COVERAGE }}'

  - script: |
      echo "PERFORM_CHECKMARX               task is $(PERFORM_CHECKMARX)"
      echo "PERFORM_DOCKER_PUSH             task is $(PERFORM_DOCKER_PUSH)"
      echo "PERFORM_DOCKER_BUILD            task is $(PERFORM_DOCKER_BUILD)"
      echo "PERFORM_BUILD_BREAKER           task is $(PERFORM_BUILD_BREAKER)"
      echo "PERFORM_AQUA                    task is $(PERFORM_AQUA)"
      echo "PERFORM_UNIT_TEST_WITH_COVERAGE task is $(PERFORM_UNIT_TEST_WITH_COVERAGE)"
    displayName: DEBUG automate task run details

```
