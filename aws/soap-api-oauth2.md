```xml
<policies>
    <inbound>
        <validate-jwt header-name="Authorization" failed-validation-httpcode="401" failed-validation-error-message="Unauthorized. Access token is missing or invalid.">
            <openid-config url="https://login.microsoftonline.com/xxxx-xxxx-xxxx-xxxxx-xxxx/v2.0/.well-known/openid-configuration" />
            <required-claims>
                <claim name="aud">
                    <value>xxxx-xxxxx-xxxx-xxxx-xxxx</value>
                </claim>
            </required-claims>
        </validate-jwt>
        <set-variable name="body" value="@(context.Request.Body.AsSoap(true).Body.Contents.ToString())" />
        <set-body template="liquid">
			<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:ns="http://www.aqssolutions.com/PolicyAdministration/2012/09" xmlns:wsa="http://www.w3.org/2005/08/addressing">
				<soap:Body>
                    {{context.Variables["body"]}}
				</soap:Body>
			</soap:Envelope>
		</set-body>
        <base />
    </inbound>
    <backend>
        <base />
    </backend>
    <outbound>
        <base />
    </outbound>
    <on-error>
        <base />
    </on-error>
</policies>
```
