_[Configure OpenID Connect in AWS to retrieve temporary credentials](https://docs.gitlab.com/ee/ci/cloud_services/aws/)_

Create the  `Identity providers`  under the aws IAM Console

_Add the identity provider_

  Create GitLab as a IAM OIDC provider in AWS following these instructions.

_ Include the following information_

```service
1. **Provider URL**: The address of your GitLab instance, such as `https://gitlab.com` or `http://gitlab.example.com`.
2. **Audience**: The address of your GitLab instance, such as `https://gitlab.com` or `http://gitlab.example.com`.
```
Note: _The address must include https://. Do not include a trailing slash._

Once the OIDC provider is created, it will look like this.

![image](https://user-images.githubusercontent.com/57703276/218640085-c9ca31d5-357c-4a80-9122-559c29a8a17a.png)
