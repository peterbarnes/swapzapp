module Api
  module V1
    class InventoriesController < ApiController
      resource_description do
        short 'Inventories represent categorized groups of items'
        formats ['JSON']
        api_base_url '/api/v1'
      end
      
      skip_filter :user_time_zone
      
      respond_to :json
      
      api :GET, "/inventories/", "Retrieve an array of inventories based on given filter params"
      param :search, String, :desc => "Full text query string for searching results"
      param :sort, String, :desc => "Property with which to sort results"
      param :order, ['ASC', 'DESC'], :desc => "Order in which to sort results (Default: ASC)"
      param :page, Integer, :desc => "The page number to return (Default: 1)"
      param :per_page, Integer, :desc => "The quantity of results per page (Default: 10)"
      param :items, Boolean, :desc => "Include items in results"
      meta ['total', 'per_page', 'page']
      example <<-EOS
      {
        "inventories": [
          {
            "id": "533aa705f6f407fccf00047d",
            "name": "Afterbalt",
            "description": "Ab eum optio est et est doloribus possimus.",
            "created_at": "2014-04-01T11:46:13Z",
            "updated_at": "2014-04-01T11:46:13Z"
          },
          {
            "id": "533aa705f6f407fccf000469",
            "name": "Amfunc",
            "description": "Error soluta in eum eius consequatur in.",
            "created_at": "2014-04-01T11:46:13Z",
            "updated_at": "2014-04-01T11:46:13Z"
          },
          ...
          {
            "id": "533aa705f6f407fccf000473",
            "name": "Brione",
            "description": "Ad natus similique eligendi quas.",
            "created_at": "2014-04-01T11:46:13Z",
            "updated_at": "2014-04-01T11:46:13Z"
          }
        ],
        "meta": {
          "total": 40,
          "per_page": 10,
          "page": 1
        }
      }
      EOS
      def index
        @inventories = Inventory.search(params[:search]).sorted(params[:sort], params[:order])
        @inventories = @inventories.paginate(:page => params[:page], :per_page => params[:per_page] == '0' ? @inventories.count : params[:per_page])
        @meta = { :total => @inventories.total_entries, :per_page => @inventories.per_page, :page => @inventories.current_page }
        
        respond_with @inventories, :each_serializer => InventoryIndexSerializer, :meta => @meta
      end
      
      api :GET, "/inventories/:id", "Show inventory with given ID"
      param :id, String, :required => true
      error 404, "Not Found"
      example <<-EOS
      {
        "inventory": {
          "id": "533aa705f6f407fccf00047d",
          "name": "Afterbalt",
          "description": "Ab eum optio est et est doloribus possimus.",
          "created_at": "2014-04-01T11:46:13Z",
          "updated_at": "2014-04-01T11:46:13Z"
        }
      }
      EOS
      def show
        respond_with Inventory.find(params[:id])
      end
      
      api :POST, "/inventories", "Create a new inventory with given params"
      param :inventory, Hash, :required => true do
        param :name, String
        param :description, String
      end
      error 422, "Unprocessable Entity"
      example <<-EOS
      {
        "inventory": {
          "name": "Afterbalt",
          "description": "Ab eum optio est et est doloribus possimus."
        }
      }
      EOS
      def create
        respond_with current_account.inventories.create(params[:inventory])
      end
      
      api :PUT, "/inventories/:id", "Update an inventory with given params"
      param :id, String, :required => true
      param :inventory, Hash, :required => true do
        param :name, String
        param :description, String
      end
      error 404, "Not Found"
      error 422, "Unprocessable Entity"
      example <<-EOS
      {
        "inventory": {
          "name": "Afterbalt",
          "description": "Ab eum optio est et est doloribus possimus."
        }
      }
      EOS
      def update
        respond_with Inventory.find(params[:id]).update_attributes(params[:inventory])
      end
      
      api :DELETE, "/inventories/:id", "Destroy inventory with given ID"
      param :id, String, :required => true
      error 404, "Not Found"
      example <<-EOS
        200 OK
      EOS
      def destroy
        respond_with Inventory.destroy(params[:id])
      end
    end
  end
end