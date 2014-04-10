module Api
  module V1
    class TillsController < ApiController
      resource_description do
        short 'Tills track money exchanged during transactions'
        formats ['JSON']
        api_base_url '/api/v1'
      end
      
      def_param_group :till do
        param :till, Hash, :required => true, :action_aware => true do
          param :store_id, String, :required => true
          param :user_id, String, :required => true
          param :minimum, Integer
          param :balance, Integer
          param :name, String
          param :tax_rate, Float
          param :adjustment_attributes, Array do
            param :user_id, String, :required => true
            param :amount, Integer
            param :balance, Integer
            param :description, String
            param :title, String
          end
        end
      end
      
      skip_filter :till_time_zone
      
      respond_to :json
      
      api :GET, "/tills/", "Retrieve an array of tills based on given filter params"
      param :search, String, :desc => "Full text query string for searching results"
      param :sort, String, :desc => "Property with which to sort results"
      param :order, ['ASC', 'DESC'], :desc => "Order in which to sort results (Default: ASC)"
      param :page, Integer, :desc => "The page number to return (Default: 1)"
      param :per_page, Integer, :desc => "The quantity of results per page (Default: 10)"
      param :adjustments, Boolean, :desc => "Include adjustments in results"
      param :store, Boolean, :desc => "Include store in results"
      param :user, Boolean, :desc => "Include user in results"
      param :user_id, String, :desc => "Filter results by user ID"
      param :store_id, String, :desc => "Filter results by store ID"
      param :unassigned, Boolean, :desc => "Only return unassigned tills"
      meta ['total', 'per_page', 'page']
      example <<-EOS
      {
        "tills": [
          {
            "id": "533aa705f6f407fccf000430",
            "store_id": "533aa6dbf6f407fccf000392",
            "user_id": "533aa62ff6f407fccf000002",
            "minimum": 0,
            "balance": -1428,
            "name": "Till 0BB4",
            "tax_rate": 0.075,
            "created_at": "2014-04-01T11:46:13Z",
            "updated_at": "2014-04-06T19:55:08Z"
          },
          {
            "id": "533aa705f6f407fccf000436",
            "store_id": "533aa6dbf6f407fccf000392",
            "user_id": null,
            "minimum": 0,
            "balance": 0,
            "name": "Till 1A15",
            "tax_rate": 0.07,
            "created_at": "2014-04-01T11:46:13Z",
            "updated_at": "2014-04-06T19:54:28Z"
          },
          ...
          {
            "id": "533aa705f6f407fccf00042a",
            "store_id": "533aa6d5f6f407fccf00035a",
            "user_id": null,
            "minimum": 0,
            "balance": -9015,
            "name": "Till 43F7",
            "tax_rate": 0.06,
            "created_at": "2014-04-01T11:46:13Z",
            "updated_at": "2014-04-01T11:46:13Z"
          }
        ],
        "meta": {
          "total": 34,
          "per_page": 10,
          "page": 1
        }
      }
      EOS
      def index
        @tills = Till.search(params[:search]).sorted(params[:sort], params[:order]).user_id(params[:user_id]).store_id(params[:store_id]).unassigned(params[:unassigned])
        @tills = @tills.paginate(:page => params[:page], :per_page => params[:per_page] == '0' ? @tills.count : params[:per_page])
        @meta = { :total => @tills.total_entries, :per_page => @tills.per_page, :page => @tills.current_page }
        
        respond_with @tills, :each_serializer => TillIndexSerializer, :meta => @meta
      end
      
      api :GET, "/tills/:id", "Show till with given ID"
      param :id, String, :required => true
      error 404, "Not Found"
      example <<-EOS
      {
        "till": {
          "id": "533aa705f6f407fccf000430",
          "store_id": "533aa6dbf6f407fccf000392",
          "user_id": "533aa62ff6f407fccf000002",
          "minimum": 0,
          "balance": -1428,
          "name": "Till 0BB4",
          "tax_rate": 0.075,
          "created_at": "2014-04-01T11:46:13Z",
          "updated_at": "2014-04-06T19:55:08Z",
          "store": {...},
          "user": {...}
        }
      }
      EOS
      def show
        respond_with Till.find(params[:id])
      end
      
      api :GET, "/tills/:id/metadata", "Show metadata for till with given ID"
      param :id, String, :required => true
      error 404, "Not Found"
      example <<-EOS
      {
        "till": {
          "id": "533aa705f6f407fccf000430",
          "socket": {
            "url": "http:\/\/localhost:3000",
            "port": 3000,
            "namespace": "e432a553351714d4f36dad2fc58817b810368f57e3f59c4aafb569e8112621f7"
          },
          "name": "Till 0BB4"
        }
      }
      EOS
      def metadata
        respond_with TillMetadataSerializer.new(Till.find(params[:id]), :root => 'till')
      end
      
      api :POST, "/tills", "Create a new till with given params"
      param_group :till
      error 422, "Unprocessable Entity"
      example <<-EOS
      {
        "till": {
          "store_id": "533aa6dbf6f407fccf000392",
          "user_id": "533aa62ff6f407fccf000002",
          "minimum": 0,
          "balance": -1428,
          "name": "Till 0BB4",
          "tax_rate": 0.075,
          "adjustment_attributes": [
            {
              "user_id": "533aa630f6f407fccf000005",
              "amount": 0,
              "balance": 0,
              "description": "Doloribus labore laudantium saepe corrupti ex ratione quia et.",
              "title": "Initial Adjustment"
            }
          ]
        }
      }
      EOS
      def create
        respond_with current_account.tills.create(params[:till])
      end
      
      api :PUT, "/tills/:id", "Update a till with given params"
      param :id, String, :required => true
      param_group :till
      error 404, "Not Found"
      error 422, "Unprocessable Entity"
      example <<-EOS
      {
        "till": {
          "store_id": "533aa6dbf6f407fccf000392",
          "user_id": "533aa62ff6f407fccf000002",
          "minimum": 0,
          "balance": -1428,
          "name": "Till 0BB4",
          "tax_rate": 0.075,
          "adjustment_attributes": [
            {
              "user_id": "533aa630f6f407fccf000005",
              "amount": 0,
              "balance": 0,
              "description": "Doloribus labore laudantium saepe corrupti ex ratione quia et.",
              "title": "Initial Adjustment"
            }
          ]
        }
      }
      EOS
      def update
        respond_with Till.find(params[:id]).update_attributes(params[:till])
      end
      
      api :DELETE, "/tills/:id", "Destroy till with given ID"
      param :id, String, :required => true
      error 404, "Not Found"
      example <<-EOS
        200 OK
      EOS
      def destroy
        respond_with Till.destroy(params[:id])
      end
    end
  end
end