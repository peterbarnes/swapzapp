class PosController < BaseController
  protect_from_forgery
  
  around_filter :scope_current_account
  around_filter :user_time_zone, :if => :current_user
  before_filter :authenticate
  
  layout 'pos'
  
  def index
    @account = AccountSerializer.new(current_account).to_json(root: false)
    @user = UserPosSerializer.new(current_user).to_json(root: false)
    @socket_url = Rails.env.production? ? ENV['SOCKET_URL'] : 'http://localhost:3000'
    
    render
  end
  
  protected
  
  def authenticate
    unless current_user
      redirect_to login_path
    end
  end
end