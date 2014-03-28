class ApiController < BaseController
  around_filter :scope_current_account
  before_filter :authorize
  
  serialization_scope :view_context
  
  protected
  
  def authorize
    unless current_user
      authenticate_or_request_with_http_basic do |username, password|
        username == "x" && password == current_account.api_secret && current_account.api_active
      end
    end
  end
end