class AuthenticationController < BaseController
  protect_from_forgery
  
  around_filter :scope_current_account
end