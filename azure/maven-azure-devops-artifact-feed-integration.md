maven-azure-devops-artifact-feed-integration.md

There are two types of `pom.xml` files available. If global level pom.xml and project level `pom.xml` exist, we should add all that information under `pom.xml`.

The `pom.xml` xml section should be changed like this:

```xml
    <repositories>
        <repository>
            <id>xxxx</id>
            <url>https://pkgs.dev.azure.com/xxxx/xxxxx/_packaging/xxxxx/maven/v1</url>
            <releases>
                <enabled>true</enabled>
            </releases>
            <snapshots>
                <enabled>true</enabled>
            </snapshots>
        </repository>
    </repositories>
    <distributionManagement>
        <repository>
            <id>xxxx</id>
            <url>https://pkgs.dev.azure.com/xxxx/xxxxx/_packaging/xxxxx/maven/v1</url>
        </repository>
        <snapshotRepository>
            <id>xxxx</id>
            <url>https://pkgs.dev.azure.com/xxxx/xxxxx/_packaging/xxxxx/maven/v1</url>
        </snapshotRepository>
    </distributionManagement>
```
_note_

Do not overlap any other existing section with `pom.xml`. Make it clear that if there is a conflict in the `pom.xml` file, the build process should fail. 

_Important notes_

If your application requires custom libraries, make sure they are included in the Azure Artifacts feed. It is not available in Azure Feed until the apps are built.
You should trigger the custom library pipeline first and make sure your library is available under Azure Feed.

_Build pipeline process_

The build pipeline will inject the `maven credentials` while building the jar file.


```yml
  - script: |
      cat > "${component}/settings.xml" <<EOF
      <settings xmlns="http://maven.apache.org/SETTINGS/1.0.0"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                xsi:schemaLocation="http://maven.apache.org/SETTINGS/1.0.0
                                    https://maven.apache.org/xsd/settings-1.0.0.xsd">
        <servers>
          <server>
            <id>${azureFeedName}</id>
            <username>${azureFeedUsername}</username>
            <password>${azureFeedPatToken}</password>
          </server>
        </servers>
      </settings>
      EOF
      cat "${component}/settings.xml"
    env:
      azureFeedName: ${{ parameters.azureFeedName }}
      azureFeedUsername: ${{ parameters.azureFeedUsername }}
      azureFeedPatToken: ${{ parameters.azureFeedPatToken }}
      component: ${{ parameters.component }}
    displayName: 'Create Maven Authentication file'
```

_variable group_

all the credentials are already exist under library in the name of `azure-feed-artifacts-service-connections`. under this variable group. As of now, I declare three variables; two are unchanged, and only token changes are required if an error occurs. 
