# LogonLabs Ruby
---
The official LogonLabs Ruby API library.

### Install LogonLabs Gem
---
From the command line:
  gem install logonlabs

## Logon Labs API
---

- Prior to coding, some configuration is required at https://app.logonlabs.com/app/#app-settings.

- For the full Developer Documentation please visit: https://app.logonlabs.com/api/

---
### Instantiating a new client

- Your `APP_ID` can be found in [App Settings](https://app.logonlabs.com/app/#/app-settings)
- `APP_SECRETS` are configured [here](https://app.logonlabs.com/app/#/app-secrets)
- The `LOGONLABS_API_ENDPOINT` should be set to `https://api.logonlabs.com`

Create a new instance of `LogonClient`.  

```ruby
require('logonlabs_gem')

client = LogonClient.new('{LOGONLABS_API_ENDPOINT}', '{APP_ID}', '{APP_SECRET}')

```
---
### SSO Login QuickStart

The StartLogin function in the JS library begins the Logon Labs managed SSO process.  

>Further documentation on starting the login process via our JavaScript client can be found at our GitHub page [here](https://github.com/logonlabs/logonlabs-js)

The following example demonstrates what to do once the `Callback Url` has been used by our system to redirect the user back to your page:

```ruby
require('logonlabs_gem')
require('logonlabs_constants')

client = LogonClient.new('{LOGONLABS_API_ENDPOINT}', '{APP_ID}', '{APP_SECRET}')#NOTE: we assume you are using ruby on rails, if you're using something else how you get the query parameters may have to be different.
token = request.query_parameters[Constants::QueryString::token];

response = client.validateLogin(token)

eventId = response.event_id #used to update the SSO event later via UpdateEvent

if(response.event_success) 
{
    #authentication and validation succeeded. proceed with post-auth workflows (ie, create a user session token for your system).
}

```
---
### Ruby Only Workflow
The following workflow is required if you're using Ruby to handle both the front and back ends.  If this does not apply to you please refer to the SSO Login QuickStart section.
#### Step 1 - StartLogin
This call begins the Logon Labs managed SSO process.  The `clientData` property is optional and is used to pass any data that is required after validating the request.  The `tags`property is an ArrayList of type Tag which is a simple object representing a key/value pair.

```ruby
require('logonlabs_gem')
require('logonlabs_constants')

#optional parameters
clientData = "{\"ClientData\":\"Value\"}"
tags = [{:key => "example-key",
  :value => "example-value"}]

client = LogonClient.new('{LOGONLABS_API_ENDPOINT}', '{APP_ID}', '{APP_SECRET}')

redirectUri = client.start_login(Constants::IdentityProviders::GOOGLE, nil, "example@emailaddress.com", clientData, nil, nil, tags);
```
The `redirectUri` property returned should be redirected to by the application.  Upon the user completing entering their credentials they will be redirected to the `CallbackUrl` set within the application settings at https://app.logonlabs.com/app/#/app-settings.

#### Step 2 - ValidateLogin
This method is used to validate the results of the login attempt.  `queryToken` corresponds to the query parameter with the name `token` appended to the callback url specified for your app.

The response contains all details of the login and the user has now completed the SSO workflow.  If there is any additional information to add UpdateEvent can be called on the `eventId` returned.
```ruby
require('logonlabs_gem')
require('logonlabs_constants')

#NOTE: depending on what flavor of .NET you are using (Asp.Net Core, .NET Framework), the code to extract the header value could be slightly different
token = Request.Query[Constants::QueryString::token];

client = LogonClient.new('{LOGONLABS_API_ENDPOINT}', '{APP_ID}', '{APP_SECRET}')

response = client.validate_login(token);

if response.event_success
    #authentication and validation succeeded. proceed with post-auth workflows (ie, create a user session token for your system).
else 
    #some validations failed.  details contained in SsoValidationDetails object.
    ValidationDetails validationDetails = response.validation_details;
	
    if validationDetails.domain_validation == Constants::EventValidationTypes::FAIL
        #provider used was not enabled for the domain of the user that was authenticated
    end
	
    if validationDetails.geo_validation == Constants::EventValidationTypes::FAIL
        || validationDetails.ip_validation == Constants::EventValidationTypes::FAIL
        || validationDetails.time_validation == Constants::EventValidationTypes::FAIL
        //validation failed via restriction settings for the app
    end

end

```
---
### CreateEvent
The CreateEvent method allows one to create events that are outside of our SSO workflows.

```ruby
require('logonlabs_gem')
require('logonlabs_constants')

validateEvent = true

tags = [{:key => "example-key",
  :value => "example-value"}]

localValidation = Constants::EventValidationTypes::PASS

client = LogonClient.new('{LOGONLABS_API_ENDPOINT}', '{APP_ID}', '{APP_SECRET}')

response = client.create_event(
    Constants::EventTypes::LOCAL_LOGIN,
    validateEvent,
    localValidation,
    "{IP_ADDRESS}",
    "{EMAIL_ADDRESS}",
    "{FIRST_NAME}",
    "{LAST_NAME}",
    "{USER_AGENT}",
    tags)

```

---
### Helper Methods
#### GetProviders
This method is used to retrieve a list of all providers enabled for the application.
If an email address is passed it will further filter any providers available/disabled for the domain of the address.  
If any Enterprise Identity Providers have been configured a separate set of matching providers will also be returned in enterprise_identity_providers.
```ruby
require('logonlabs_gem')

client = LogonClient.new('{LOGONLABS_API_ENDPOINT}', '{APP_ID}', '{APP_SECRET}')

response = client.get_providers("example@emailaddress.com")
var suggestedProvider = response.suggested_identity_provider #use suggested provider in UI
response.social_identity_providers.each do |provider|
    #each individual provider available for this app / email address
end

response.enterprise_identity_providers.each do |enterpriseProvider|
    #each enterprise provider available for this app / email address
end
```