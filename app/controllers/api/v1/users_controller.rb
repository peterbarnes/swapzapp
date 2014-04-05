module Api
  module V1
    class UsersController < ApiController
      resource_description do
        short 'Users'
        formats ['json']
        # param :id, Fixnum, :desc => "User ID", :required => false
        # param :resource_param, Hash, :desc => 'Param description for all methods' do
        #   param :ausername, String, :desc => "Username for login", :required => true
        #   param :apassword, String, :desc => "Password for login", :required => true
        # end
        error 401, "Unauthorized"
        error 404, "Missing"
        error 500, "Server crashed"
        description <<-EOS
          == Long description
           Example resource for rest api documentation
           These can now be accessed in <tt>shared/header</tt> with:
             Headline: <%= headline %>
             First name: <%= person.first_name %>

           If you need to find out whether a certain local variable has been
           assigned a value in a particular render call, you need to use the
           following pattern:

           <% if local_assigns.has_key? :headline %>
              Headline: <%= headline %>
           <% end %>

          Testing using <tt>defined? headline</tt> will not work. This is an
          implementation restriction.

          === Template caching

          By default, Rails will compile each template to a method in order
          to render it. When you alter a template, Rails will check the
          file's modification time and recompile it in development mode.
        EOS
      end
      
      skip_filter :user_time_zone
      skip_filter :authorize, :only => [:authenticate]
      
      respond_to :json
      
      api :GET, "/users/", "Show all users"
      #param :session, String, :desc => "user is logged in", :required => true
      #param :boolean_param, [true, false], :desc => "array validator with boolean"
      description "Show all users..."
      example " 'users': {...} "
      def index
        @users = User.search(params[:search]).sorted(params[:sort])
        @users = @users.paginate(:page => params[:page], :per_page => params[:per_page] == '0' ? @users.count : params[:per_page])
        @meta = { :total => @users.total_entries, :per_page => @users.per_page, :page => @users.current_page }
        
        respond_with @users, :each_serializer => UserIndexSerializer, :meta => @meta
      end
      
      def authenticate
        respond_with User.authenticate(params[:email], params[:password]), :serializer => UserAuthenticateSerializer, :root => 'user'
      end
      
      api :GET, "/users/:id", "Show user"
      #param :session, String, :desc => "user is logged in", :required => true
      #param :boolean_param, [true, false], :desc => "array validator with boolean"
      description "Show user..."
      example " 'user': {...} "
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