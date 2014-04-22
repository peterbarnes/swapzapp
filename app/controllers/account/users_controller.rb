class Account::UsersController < AdminController
  respond_to :html
  
  before_filter :find_user, :only => [:show, :edit, :update, :destroy]
  
  def index
    @users = User.search(params[:search]).sorted(params[:sort], params[:order])
    @users = @users.paginate(:page => params[:page], :per_page => params[:per_page])
    
    respond_with @users
  end
  
  def new
    @user = User.new(:account => current_account)
    respond_with @user
  end
  
  def show
    respond_with @user
  end
  
  def create
    @user = User.create(params[:user])
    respond_with @user
  end
  
  def edit
    respond_with @user
  end
  
  def update
    @user.update_attributes(params[:user])
    respond_with @user
  end
  
  def destroy
    @user.destroy
    respond_with @user
  end
  
  private
  
  def find_user
    @user = User.find(params[:id])
  end
end