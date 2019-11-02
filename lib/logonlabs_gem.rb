require 'rest-client'
require 'json'

class LogonClient
  def initialize(base_url, app_id, app_secret)
    @base_url = base_url
    @app_id = app_id
    @app_secret = app_secret
  end
  
  def ping()
    puts("#{@base_url}/ping?app_id=#{@app_id}")
    response = RestClient.get("#{@base_url}/ping?app_id=#{@app_id}")
    return JSON.parse(response)
  end
  
  def start_logon(identity_provider, identity_provider_id=nil, email_address=nil, clientData=nil, clientEncryptionKey=nil, tags=nil)    
    response = RestClient.post "#{@base_url}/start", 
        {'app_id' => @app_id, 'identity_provider' => identity_provider, 'identity_provider_id' => identity_provider_id,
         'email_address' => email_address, 'client_data' => clientData, 'client_encryption_key' => clientEncryptionKey,
         'tags' => tags}.to_json, 
        {content_type: :json, accept: :json}
    # https://api.logon-dev.com/redirect?token=dd6711cfe6ff46c8ae598b8bebbceeb4
    respObj = JSON.parse(response)
    return "#{@base_url}/redirect?token=#{respObj['token']}"
  end
  
  def get_providers(email_address=nil)
    response = RestClient.get("#{@base_url}/providers?app_id=#{@app_id}&email_address=#{@email_address}")
    respObj = JSON.parse(response)
    return respObj
  end

  def validate_login(token)
    response = RestClient.post("#{@base_url}/validate", {:app_id => @app_id, :token => token}.to_json, 
        {content_type: :json, accept: :json, 'x-app-secret': @app_secret})
    respObj = JSON.parse(response)
    return respObj
  end
  
  def update_event(event_id, local_validation=nil, tags=nil)
    response = RestClient.put("#{base_url}/event/#{event_id}", {:app_id => @app_id, :local_validation => local_validation, :tags => tags}.to_json, {content_type: :json, accept: :json, :x-app-secret => 'EYN8iF14epcl52v/ILiTAGOwOdB6B1kNtE8NxZiWBKs='})
    respObj = JSON.parse(response)
    return respObj
  end
  
  def create_event(type, validate, local_validation, email_address, ip_address, user_agent=nil, first_name=nil, last_name=nil, tags=nil)
    response = RestClient.post("#{base_url}/event", {:app_id => @app_id, :validate => validate, :local_validation => local_validation, :email_address => email_address,
        :ip_address => ip_address, :user_agent => user_agent, :first_name => first_name, :last_name => last_name, :tags => tags}.to_json, {content_type: :json, accept: :json})
    respObj = JSON.parse(response)
    return respObj
  end
end