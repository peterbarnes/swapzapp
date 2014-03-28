module Api
  module V1
    class UsersController < ApiController
      skip_filter :user_time_zone
      skip_filter :authorize, :only => [:authenticate]
      
      respond_to :json
      
      def index
        @users = User.search(params[:search]).sorted(params[:sort])
        @users = @users.paginate(:page => params[:page], :per_page => params[:per_page] == '0' ? @users.count : params[:per_page])
        @meta = { :total => @users.total_entries, :per_page => @users.per_page, :page => @users.current_page }
        
        respond_with @users, :each_serializer => UserIndexSerializer, :meta => @meta
      end
      
      def authenticate
        respond_with User.authenticate(params[:email], params[:password]), :serializer => UserAuthenticateSerializer, :root => 'user'
      end
      
      def show
        respond_with User.find(params[:id])
      end
      
      def create
        respond_with current_account.users.create(params[:user])
      end
      
      def update
        @user = User.find(params[:id])
        @user.update_attributes(params[:user])
        respond_with @user
      end
      
      def destroy
        @user = User.find(params[:id])
        @user.destroy
        respond_with @user
      end
    end
  end
end