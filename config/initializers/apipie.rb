Apipie.configure do |config|
  config.app_name                = "Swapzapp"
  config.api_base_url            = "/api"
  config.doc_base_url            = "/apidoc"
  config.default_version         = "v1"
  config.copyright               = "&copy; #{Time.now.year} Infinite Token"
  config.validate                = false
  config.markup                  = Apipie::Markup::Markdown.new
  config.reload_controllers      = Rails.env.development?
  config.api_controllers_matcher = "#{Rails.root}/app/controllers/api/v1/*.rb"
  config.app_info                = "
    Usage
    =====
    
    ***
    
    This API uses HTTP Basic Auth to authenticate API users. 
    To connect to this API you will need your API Secret from the Account -> Settings page.
    
    You can either pass the credentials as part of the URL like this:
    
        http://x:my_api_secret@example.swapzapp.com/api/...
    
    Or by setting an Authorization header with the user and password Base 64 encoded:
        
        Authorization: Basic <base64 encoded hash>
        
    The username for all API requests is always simply ``x`` and the password is your API Secret.
  "
end
