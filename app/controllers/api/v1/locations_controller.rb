module Api
  module V1
    class LocationsController < ApiController
      resource_description do
        short 'Locations represent physical spots where units can be placed'
        formats ['JSON']
        api_base_url '/api'
      end
      
      def_param_group :location do
        param :location, Hash, :required => true, :action_aware => true do
          param :store_id, String, :required => true
          param :description, String
          param :name, String
          param :restock, Integer
          param :sku, String
          param :target, Integer
          param :image_attributes, Array do
            param :name, String
            param :index, Integer
            param :description, String
            param :image_url, String
          end
        end
      end
      
      skip_filter :user_time_zone
      
      respond_to :json
      
      api :GET, "/locations/", "Retrieve an array of locations based on given filter params"
      param :search, String, :desc => "Full text query string for searching results"
      param :sort, String, :desc => "Property with which to sort results"
      param :order, ['ASC', 'DESC'], :desc => "Order in which to sort results (Default: ASC)"
      param :page, Integer, :desc => "The page number to return (Default: 1)"
      param :per_page, Integer, :desc => "The quantity of results per page (Default: 10)"
      param :store_id, String, :desc => "Filter results by store ID"
      param :store, Boolean, :desc => "Include store in results"
      meta ['total', 'per_page', 'page']
      example <<-EOS
      {
        "locations": [
          {
            "id": "533aa702f6f407fccf000412",
            "store_id": "533aa6d7f6f407fccf00036e",
            "description": "Modi quos tenetur aspernatur iste nostrum.",
            "name": "Barcelona Business Center",
            "restock": 72,
            "sku": "234D4938D7FEC41F",
            "target": 97,
            "created_at": "2014-04-01T11:46:10Z",
            "updated_at": "2014-04-01T11:46:10Z"
          },
          {
            "id": "533aa6edf6f407fccf0003d2",
            "store_id": "533aa6dcf6f407fccf00039d",
            "description": "Ut sint corrupti rerum et molestiae dolores.",
            "name": "Can Domenge. Centre Tecnologic",
            "restock": 6,
            "sku": "53A5C3A65D2BD563",
            "target": 21,
            "created_at": "2014-04-01T11:45:49Z",
            "updated_at": "2014-04-01T11:45:49Z"
          },
          ...
          {
            "id": "533aa6f4f6f407fccf0003ec",
            "store_id": "533aa6d8f6f407fccf000376",
            "description": "Minus tenetur inventore aliquam.",
            "name": "Centro de Eventos Castillo Hidalgo",
            "restock": 12,
            "sku": "D8B2B575770CCEFB",
            "target": 8,
            "created_at": "2014-04-01T11:45:56Z",
            "updated_at": "2014-04-01T11:45:56Z"
          }
        ],
        "meta": {
          "total": 57,
          "per_page": 10,
          "page": 1
        }
      }
      EOS
      def index
        @locations = Location.search(params[:search]).sorted(params[:sort], params[:order]).store_id(params[:store_id])
        @locations = @locations.paginate(:page => params[:page], :per_page => params[:per_page] == '0' ? @locations.count : params[:per_page])
        @meta = { :total => @locations.total_entries, :per_page => @locations.per_page, :page => @locations.current_page }
        
        respond_with @locations, :each_serializer => LocationIndexSerializer, :meta => @meta
      end
      
      api :GET, "/locations/:id", "Show location with given ID"
      param :id, String, :required => true
      error 404, "Not Found"
      example <<-EOS
      {
        "location": {
          "id": "533aa702f6f407fccf000412",
          "store_id": "533aa6d7f6f407fccf00036e",
          "description": "Modi quos tenetur aspernatur iste nostrum.",
          "name": "Barcelona Business Center",
          "restock": 72,
          "sku": "234D4938D7FEC41F",
          "target": 97,
          "created_at": "2014-04-01T11:46:10Z",
          "updated_at": "2014-04-01T11:46:10Z",
          "image": {
            "id": "533aa702f6f407fccf000413",
            "name": "Trient",
            "index": 0,
            "description": "Maiores necessitatibus et est placeat.",
            "image_url": "\/system\/images\/images\/533a\/a702\/f6f4\/07fc\/cf00\/0413\/original\/200?1396352770"
          },
          "store": {
            "id": "533aa6d7f6f407fccf00036e",
            "description": "Hic laboriosam ullam rem aut dolores.",
            "legal": "Sapiente non quaerat dolore quae unde consequuntur aut officiis. Ad at animi perspiciatis est quidem autem velit. Et ut fugiat sed molestias rerum nobis perferendis est. Voluptate expedita repudiandae totam velit cum soluta.",
            "name": "Nienow, Swaniawski and Kertzmann",
            "created_at": "2014-04-01T11:45:27Z",
            "updated_at": "2014-04-01T11:45:27Z",
            "image": {
              "id": "533aa6d7f6f407fccf000370",
              "name": "Peffe",
              "index": 0,
              "description": "Amet corrupti minus quibusdam commodi doloremque.",
              "image_url": "\/system\/images\/images\/533a\/a6d7\/f6f4\/07fc\/cf00\/0370\/original\/200?1396352727"
            }
          }
        }
      }
      EOS
      def show
        respond_with Location.find(params[:id])
      end
      
      api :POST, "/locations", "Create a new location with given params"
      param_group :location
      error 422, "Unprocessable Entity"
      example <<-EOS
      {
        "location": {
          "store_id": "533aa6d7f6f407fccf00036e",
          "description": "Modi quos tenetur aspernatur iste nostrum.",
          "name": "Barcelona Business Center",
          "restock": 72,
          "sku": "234D4938D7FEC41F",
          "target": 97,
          "image": {
            "name": "Trient",
            "index": 0,
            "description": "Maiores necessitatibus et est placeat.",
            "image_url": "\/system\/images\/images\/533a\/a702\/f6f4\/07fc\/cf00\/0413\/original\/200?1396352770"
          }
        }
      }
      EOS
      def create
        respond_with current_account.locations.create(params[:location])
      end
      
      api :PUT, "/locations/:id", "Update an location with given params"
      param :id, String, :required => true
      param_group :location
      error 404, "Not Found"
      error 422, "Unprocessable Entity"
      example <<-EOS
      {
        "location": {
          "store_id": "533aa6d7f6f407fccf00036e",
          "description": "Modi quos tenetur aspernatur iste nostrum.",
          "name": "Barcelona Business Center",
          "restock": 72,
          "sku": "234D4938D7FEC41F",
          "target": 97,
          "image": {
            "name": "Trient",
            "index": 0,
            "description": "Maiores necessitatibus et est placeat.",
            "image_url": "\/system\/images\/images\/533a\/a702\/f6f4\/07fc\/cf00\/0413\/original\/200?1396352770"
          }
        }
      }
      EOS
      def update
        respond_with Location.find(params[:id]).update_attributes(params[:location])
      end
      
      api :DELETE, "/locations/:id", "Destroy location with given ID"
      param :id, String, :required => true
      error 404, "Not Found"
      example <<-EOS
        200 OK
      EOS
      def destroy
        respond_with Location.destroy(params[:id])
      end
    end
  end
end