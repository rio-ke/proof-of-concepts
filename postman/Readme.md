Make a run-time environment variable and assign a value to it.

```js
{
    "token_type": "Bearer",
    "expires_in": "3599",
    "ext_expires_in": "3599",
    "expires_on": "1675927837",
    "not_before": "1675923937",
    "resource": "https://management.azure.com/",
    "access_token": "WxKc_zQvfEQbcQtkciZ3_6GYhBDCUCxSEftNsvCg1tJMYiU_EVP9pFwI0A"
}
```

This is the value used when calling the API to get the response.That response contains all the values. In that case, we should only require the access_token to hit all other APIs.

```bash
var res = pm.response.json();
pm.environment.set('token', res.access_token);
```
