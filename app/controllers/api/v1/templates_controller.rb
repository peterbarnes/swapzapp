module Api
  module V1
    class TemplatesController < ApiController
      resource_description do
        short 'Templates are visual representations of receipts for transactions'
        formats ['JSON']
        api_base_url '/api'
      end
      
      skip_filter :user_time_zone
      
      respond_to :json
      
      api :GET, "/templates/", "Retrieve an array of templates based on given filter params"
      param :search, String, :desc => "Full text query string for searching results"
      param :sort, String, :desc => "Property with which to sort results"
      param :order, ['ASC', 'DESC'], :desc => "Order in which to sort results (Default: ASC)"
      param :page, Integer, :desc => "The page number to return (Default: 1)"
      param :per_page, Integer, :desc => "The quantity of results per page (Default: 10)"
      param :category, String, :desc => "Filter results by category"
      meta ['total', 'per_page', 'page']
      example <<-EOS
      {
        "templates": [
          {
            "id": "5341c72ef6f407e8c5000004",
            "name": "Example",
            "category": "sale",
            "body": "...",
            "primary": true
          },
          ...
          {
            "id": "5341c93df6f4079b28000005",
            "name": "Example Purchase",
            "category": "purchase",
            "body": "...",
            "primary": true
          }
        ],
        "meta": {
          "total": 3,
          "per_page": 10,
          "page": 1
        }
      }
      EOS
      def index
        @templates = current_account.templates.searched(params[:search]).sorted(params[:sort], params[:order]).categorized(params[:category])
        @templates = @templates.paginate(:page => params[:page], :per_page => params[:per_page] == '0' ? @templates.count : params[:per_page])
        @meta = { :total => @templates.total_entries, :per_page => @templates.per_page, :page => @templates.current_page }
        
        respond_with @templates, :each_serializer => TemplateIndexSerializer, :meta => @meta
      end
      
      api :GET, "/templates/:id", "Show template with given ID"
      param :id, String, :required => true
      error 404, "Not Found"
      example <<-EOS
      {
        "template": {
          "id": "5341c72ef6f407e8c5000004",
          "name": "Example",
          "category": "sale",
          "body": "...",
          "primary": true
        }
      }
      EOS
      def show
        respond_with current_account.templates.find(params[:id])
      end
      
      def_param_group :template do
        param :template, Hash, :required => true do
          param :name, String
          param :category, String
          param :body, String
          param :primary, Boolean, :desc => "Whether or not template is primary template in its category"
        end
      end
      
      api :POST, "/templates", "Create a new template with given params"
      param_group :template
      error 422, "Unprocessable Entity"
      example <<-EOS
      {
        "template": {
          "name": "Example",
          "category": "sale",
          "body": "...",
          "primary": true
        }
      }
      EOS
      def create
        respond_with current_account.templates.create(params[:template])
      end
      
      api :PUT, "/templates/:id", "Update an template with given params"
      param :id, String, :required => true
      param_group :template
      error 404, "Not Found"
      error 422, "Unprocessable Entity"
      example <<-EOS
      {
        "template": {
          "name": "Example",
          "category": "sale",
          "body": "...",
          "primary": true
        }
      }
      EOS
      def update
        respond_with current_account.templates.find(params[:id]).update_attributes(params[:template])
      end
      
      api :DELETE, "/templates/:id", "Destroy template with given ID"
      param :id, String, :required => true
      error 404, "Not Found"
      example <<-EOS
        200 OK
      EOS
      def destroy
        respond_with current_account.templates.destroy(params[:id])
      end
    end
  end
end