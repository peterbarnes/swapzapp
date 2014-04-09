module Api
  module V1
    class UsersController < ApiController
      resource_description do
        short 'Represents people who use and interact with the applications UI'
        formats ['JSON']
        api_base_url '/api/v1'
      end
      
      skip_filter :user_time_zone
      skip_filter :authorize, :only => [:authenticate]
      
      respond_to :json
      
      api :GET, "/users/", "Retrieve an array of users based on given filter params"
      param :search, String, :desc => "Full text query string for searching users"
      param :sort, String, :desc => "Property with which to sort results"
      param :order, ['ASC', 'DESC'], :desc => "Order in which to sort results (Default: ASC)"
      param :page, Integer, :desc => "The page number to return (Default: 1)"
      param :per_page, Integer, :desc => "The quantity of results per page (Default: 10)"
      param :tills, [true, false], :desc => "Include users assigned tills in results"
      param :timecards, [true, false], :desc => "Include users timecards in results"
      meta ['total', 'per_page', 'page']
      example <<-EOS
        {
          "users": [
            {
              "id": "533aa62ff6f407fccf000004",
              "active": true,
              "administrator": false,
              "email": "eulah_murazik@rohan.info",
              "first_name": "Alexandre",
              "gravatar_url": "http:\/\/gravatar.com\/avatar\/f0e81296da46d5e3d850ca0fa409f70c.png",
              "last_name": "Kunze",
              "pin": "0000",
              "time_zone": "UTC",
              "username": "cleveland_li",
              "created_at": "2014-04-01T11:42:40Z",
              "updated_at": "2014-04-01T11:42:40Z"
            },
            {
              "id": "533aa632f6f407fccf000021",
              "active": true,
              "administrator": false,
              "email": "kariane_farrell@will.com",
              "first_name": "Amely",
              "gravatar_url": "http:\/\/gravatar.com\/avatar\/97dc20a181342987cd1d61d047807efa.png",
              "last_name": "Lesch",
              "pin": "0000",
              "time_zone": "UTC",
              "username": "jacinthe.goyette_je",
              "created_at": "2014-04-01T11:42:42Z",
              "updated_at": "2014-04-01T11:42:42Z"
            },
            ...
            {
              "id": "533aa631f6f407fccf000015",
              "active": true,
              "administrator": false,
              "email": "monserrate_mraz@mclaughlinhickle.info",
              "first_name": "Charity",
              "gravatar_url": "http:\/\/gravatar.com\/avatar\/5144a9a05015a7901cfb72b430cbda92.png",
              "last_name": "Yost",
              "pin": "0000",
              "time_zone": "UTC",
              "username": "pablo_corwin_tu",
              "created_at": "2014-04-01T11:42:41Z",
              "updated_at": "2014-04-01T11:42:41Z"
            }
          ],
          "meta": {
            "total": 33,
            "per_page": 10,
            "page": 1
          }
        }
      EOS
      def index
        @users = User.search(params[:search]).sorted(params[:sort], params[:order])
        @users = @users.paginate(:page => params[:page], :per_page => params[:per_page] == '0' ? @users.count : params[:per_page])
        @meta = { :total => @users.total_entries, :per_page => @users.per_page, :page => @users.current_page }
        
        respond_with @users, :each_serializer => UserIndexSerializer, :meta => @meta
      end
      
      api :GET, "/users/authenticate", "Attempt to authenticate user by email and password"
      param :email, String, :desc => "Email"
      param :password, String, :desc => "Password"
      description "Returns empty hash if no user is found"
      example <<-EOS
        {
          "user": {
            "id": "533aa62ff6f407fccf000002",
            "active": true,
            "administrator": true,
            "email": "example@example.com",
            "first_name": "Elaina",
            "gravatar_url": "http:\/\/gravatar.com\/avatar\/23463b99b62a72f26ed677cc556c44e8.png",
            "last_name": "Johnson",
            "pin": "0000",
            "time_zone": "UTC",
            "username": "example",
            "created_at": "2014-04-01T11:42:39Z",
            "updated_at": "2014-04-01T11:42:39Z",
            "account": {
              "id": "533aa62ff6f407fccf000001",
              "api_active": true,
              "api_secret": "a6f128a09bc00131a239109add6b8334",
              "namespace": "e432a553351714d4f36dad2fc58817b810368f57e3f59c4aafb569e8112621f7",
              "title": "Example",
              "token": "example",
              "created_at": "2014-04-01T11:42:39Z",
              "updated_at": "2014-04-01T11:42:39Z"
            }
          }
        }
      EOS
      def authenticate
        respond_with User.authenticate(params[:email], params[:password]), :serializer => UserAuthenticateSerializer, :root => 'user'
      end
      
      api :GET, "/users/:id", "Show user with given ID"
      param :id, String, :required => true
      param :tills, [true, false], :desc => "Include users assigned tills in results"
      param :timecards, [true, false], :desc => "Include users timecards in results"
      error 404, "Not Found"
      example <<-EOS
        {
          "user": {
            "id": "533aa62ff6f407fccf000004",
            "active": true,
            "administrator": false,
            "email": "eulah_murazik@rohan.info",
            "first_name": "Alexandre",
            "gravatar_url": "http:\/\/gravatar.com\/avatar\/f0e81296da46d5e3d850ca0fa409f70c.png?s=48",
            "last_name": "Kunze",
            "pin": "0000",
            "time_zone": "UTC",
            "username": "cleveland_li",
            "created_at": "2014-04-01T11:42:40Z",
            "updated_at": "2014-04-01T11:42:40Z"
          }
        }
      EOS
      def show
        respond_with User.find(params[:id])
      end
      
      api :POST, "/users", "Create new user with given params"
      param :user, Hash, :required => true do
        param :active, Boolean, "Whether or not user is active"
        param :administrator, Boolean, "Whether or not user is administrator"
        param :email, String, :required => true
        param :first_name, String, :required => true
        param :last_name, String, :required => true
        param :password, String, :required => true
        param :password_confirmation, String, :required => true
        param :pin, String, "Four digit PIN number", :required => true
        param :time_zone, ActiveSupport::TimeZone, "Time zone name as string", :required => true
      end
      error 422, "Unprocessable Entity"
      example <<-EOS
        {
          "user": {
            "active": true,
            "administrator": false,
            "email": "eulah_murazik@rohan.info",
            "first_name": "Alexandre",
            "last_name": "Kunze",
            "password": "password",
            "password_confirmation": "password",
            "pin": "0000",
            "time_zone": "Eastern Time (US & Canada)",
            "username": "cleveland_li"
          }
        }
      EOS
      def create
        respond_with current_account.users.create(params[:user])
      end
      
      api :PUT, "/users/:id", "Update user with given params"
      param :id, String, :required => true
      param :user, Hash, :required => true do
        param :active, Boolean, "Whether or not user is active"
        param :administrator, Boolean, "Whether or not user is administrator"
        param :email, String
        param :first_name, String
        param :last_name, String
        param :password, String
        param :password_confirmation, String
        param :pin, String, "Four digit PIN number"
        param :time_zone, ActiveSupport::TimeZone, "Time zone name as string"
      end
      error 404, "Not Found"
      error 422, "Unprocessable Entity"
      example <<-EOS
        {
          "user": {
            "active": true,
            "administrator": false,
            "email": "eulah_murazik@rohan.info",
            "first_name": "Alexandre",
            "last_name": "Kunze",
            "password": "password",
            "password_confirmation": "password",
            "pin": "0000",
            "time_zone": "Eastern Time (US & Canada)",
            "username": "cleveland_li"
          }
        }
      EOS
      def update
        @user = User.find(params[:id])
        @user.update_attributes(params[:user])
        respond_with @user
      end
      
      api :DELETE, "/users/:id", "Destroy user with given ID"
      param :id, String, :required => true
      error 404, "Not Found"
      example <<-EOS
        200 OK
      EOS
      def destroy
        @user = User.find(params[:id])
        @user.destroy
        respond_with @user
      end
    end
  end
end