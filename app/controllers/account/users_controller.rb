class Account::UsersController < AdminController
  respond_to :html
  
  before_action :find_user, :only => [:show, :edit, :update, :destroy]
  
  def index
    @users = User.search(params[:search]).sorted(params[:sort])
    @users = @users.paginate(:page => params[:page], :per_page => params[:per_page])
    
    respond_with @users
  end
  
  def new
    respond_with User.new
  end
  
  def show
    respond_with @user
  end
  
  def create
    respond_with User.create(user_params)
  end
  
  def edit
    respond_with @user
  end
  
  def update
    @user.update_attributes(user_params)
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

  def user_params
    params.require(:user).permit!
  end
end