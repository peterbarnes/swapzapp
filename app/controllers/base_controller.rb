class BaseController < ActionController::Base
  
  protected
  
  def current_user
    @current_user ||= User.where(:auth_token => cookies[:auth_token], :account => current_account, :active => true).first if cookies[:auth_token]
  end
  helper_method :current_user
  
  def current_account
    @current_account ||= Account.where(:token => request.subdomains.first).first
  end
  helper_method :current_account
  
  def user_time_zone(&block)
    Time.use_zone(ActiveSupport::TimeZone[current_user.time_zone], &block)
  end
  
  def scope_current_account
    if current_account
      Account.current_id = current_account.id
      yield
    else
      render :file => "#{Rails.root}/public/404.html", :layout => false, :status => 404
    end
  ensure
    Account.current_id = nil
  end
end