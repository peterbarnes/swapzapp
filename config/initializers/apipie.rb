Apipie.configure do |config|
  # config.app_name = "Test app"
  # config.copyright = "&copy; 2012 Pavel Pokorny"
  # config.doc_base_url = "/apidoc"
  # config.api_base_url = "/api"
  # config.validate = false
  # config.markup = Apipie::Markup::Markdown.new
  # config.reload_controllers = Rails.env.development?
  # config.api_controllers_matcher = File.join(Rails.root, "app", "controllers", "**","*.rb")
  # config.api_routes = Rails.application.routes
  # config.app_info = "
  #   This is where you can inform user about your application and API
  #   in general.
  # ", '1.0'
  # config.authenticate = Proc.new do
  #    authenticate_or_request_with_http_basic do |username, password|
  #      username == "test" && password == "supersecretpassword"
  #   end
  # end
  config.default_version         = "v1"
  config.app_name                = "Swapzapp"
  config.api_base_url            = "/api"
  config.doc_base_url            = "/apidoc"
  config.markup                  = Apipie::Markup::Markdown.new
  config.api_controllers_matcher = "#{Rails.root}/app/controllers/api/v1/*.rb"
end
