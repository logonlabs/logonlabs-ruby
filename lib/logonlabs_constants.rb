class Constants
  class ErrorCodes
    API_ERROR = 'api_error'
    VALIDATION_ERROR = 'validation_error'
    FORBIDDEN_ERROR = 'forbidden_error'
    UNAUTHORIZED_ERROR = 'unauthorized_error'
  end
  class IdentityProviders
    GOOGLE = 'google'
    MICROSOFT = 'microsoft'
    FACEBOOK = 'facebook'
    LINKEDIN = 'linkedin'
    OKTA = 'okta'
    SLACK = 'slack'
    QUICKBOOKS = 'quickbooks'
    GITHUB = 'github'
    ONELOGIN = 'onelogin'
  end
  class EventTypes
    LOCAL_LOGIN = 'LocalLogin'
    LOCAL_LOGOUT = 'LocalLogout'
  end
  class Headers
    APP_SECRET = 'x-app-secret'
  end
  class QueryString
    TOKEN = 'token';
    APP_ID = 'app_id'
  end
  class EventValidationTypes
    PASS = 'Pass'
    FAIL = 'Fail';
    NOT_APPLICABLE = 'NotApplicable'
  end
end

