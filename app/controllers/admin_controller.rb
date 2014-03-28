class AdminController < BaseController
  protect_from_forgery
  
  around_filter :scope_current_account
  around_filter :user_time_zone, :if => :current_user
  before_filter :authenticate
  
  protected
  
  def authenticate
    unless current_user
      redirect_to login_path
    else
      redirect_to pos_path unless current_user.administrator?
    end
  end
  
  def track_activity(trackable, action = params[:action])
    name = trackable.id.to_s
    name = trackable.name if trackable.respond_to?(:name)
    name = trackable.fullname if trackable.respond_to?(:fullname)
    name = trackable.title if trackable.respond_to?(:title)
    current_user.activities.create(:account => current_account, :name => name, :action => action, :trackable => trackable)
  end
end