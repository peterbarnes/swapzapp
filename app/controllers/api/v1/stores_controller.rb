module Api
  module V1
    class StoresController < ApiController
      resource_description do
        short 'Stores are physical locations which buy or sell items by creating transactions'
        formats ['JSON']
        api_base_url '/api'
      end
      
      def_param_group :store do
        param :store, Hash, :required => true, :action_aware => true do
          param :description, String
          param :legal, String
          param :name, String
          param :address_attributes, Array do
            param :name, String
            param :city, String
            param :country, String
            param :first_line, String
            param :second_line, String
            param :street, String
            param :zip, String
          end
          param :image_attributes, Array do
            param :name, String
            param :index, Integer
            param :description, String
            param :image_url, String
          end
          param :phone_attributes, Array do
            param :name, String
            param :number, String
          end
        end
      end
      
      skip_filter :user_time_zone
      
      respond_to :json
      
      api :GET, "/stores/", "Retrieve an array of stores based on given filter params"
      param :search, String, :desc => "Full text query string for searching results"
      param :sort, String, :desc => "Property with which to sort results"
      param :order, ['ASC', 'DESC'], :desc => "Order in which to sort results (Default: ASC)"
      param :page, Integer, :desc => "The page number to return (Default: 1)"
      param :per_page, Integer, :desc => "The quantity of results per page (Default: 10)"
      param :address, Boolean, :desc => "Include address in results"
      param :locations, Boolean, :desc => "Include locations in results"
      param :phones, Boolean, :desc => "Include phones in results"
      param :purchases, Boolean, :desc => "Include purchases in results"
      param :repairs, Boolean, :desc => "Include repairs in results"
      param :sales, Boolean, :desc => "Include sales in results"
      param :tills, Boolean, :desc => "Include tills in results"
      meta ['total', 'per_page', 'page']
      example <<-EOS
      {
        "stores": [
          {
            "id": "533aa6dcf6f407fccf000396",
            "description": "Dolor exercitationem beatae dolorem.",
            "legal": "Quia dolores repellat temporibus animi magnam inventore. Qui rerum aspernatur dolorem ea soluta sit qui impedit. Laboriosam deserunt et id maiores. Maxime blanditiis facilis quidem ab cupiditate eius doloribus modi.",
            "name": "Adams-Okuneva",
            "created_at": "2014-04-01T11:45:32Z",
            "updated_at": "2014-04-01T11:45:32Z",
            "image": {...}
          },
          {
            "id": "533aa6d5f6f407fccf000355",
            "description": "Eveniet ipsam aliquam ad aut.",
            "legal": "Dolores dolorem natus consequuntur quidem voluptatem recusandae aperiam enim. Praesentium fugiat dicta iste tenetur eos necessitatibus quasi est. Et et autem quia nemo. Ea ab non adipisci qui consequatur placeat rem debitis. Sed molestiae libero est.",
            "name": "Balistreri LLC",
            "created_at": "2014-04-01T11:45:25Z",
            "updated_at": "2014-04-01T11:45:25Z",
            "image": {...}
          },
          ...
          {
            "id": "533aa6daf6f407fccf00038a",
            "description": "Quo dicta nostrum explicabo nisi quas in eum.",
            "legal": "Rem hic velit repudiandae quaerat. Ipsa cumque autem explicabo ut et tempora incidunt fuga. Quidem beatae saepe ipsam enim autem. Iusto alias a ullam velit laborum laboriosam tempore.",
            "name": "Dicki LLC",
            "created_at": "2014-04-01T11:45:30Z",
            "updated_at": "2014-04-01T11:45:30Z",
            "image": {...}
          }
        ],
        "meta": {
          "total": 35,
          "per_page": 10,
          "page": 1
        }
      }
      EOS
      def index
        @stores = Store.searched(params[:search]).sorted(params[:sort], params[:order])
        @stores = @stores.paginate(:page => params[:page], :per_page => params[:per_page] == '0' ? @stores.count : params[:per_page])
        @meta = { :total => @stores.total_entries, :per_page => @stores.per_page, :page => @stores.current_page }
        
        respond_with @stores, :each_serializer => StoreIndexSerializer, :meta => @meta
      end
      
      api :GET, "/stores/:id", "Show store with given ID"
      param :id, String, :required => true
      param :locations, Boolean, :desc => "Include locations in result"
      param :purchases, Boolean, :desc => "Include purchases in result"
      param :repairs, Boolean, :desc => "Include repairs in result"
      param :sales, Boolean, :desc => "Include sales in result"
      param :tills, Boolean, :desc => "Include tills in result"
      error 404, "Not Found"
      example <<-EOS
      {
        "store": {
          "id": "533aa6dcf6f407fccf000396",
          "description": "Dolor exercitationem beatae dolorem.",
          "legal": "Quia dolores repellat temporibus animi magnam inventore. Qui rerum aspernatur dolorem ea soluta sit qui impedit. Laboriosam deserunt et id maiores. Maxime blanditiis facilis quidem ab cupiditate eius doloribus modi.",
          "name": "Adams-Okuneva",
          "created_at": "2014-04-01T11:45:32Z",
          "updated_at": "2014-04-01T11:45:32Z",
          "address": {
            "id": "533aa6dcf6f407fccf000397",
            "name": "Business",
            "city": "North Leopoldo",
            "country": "US",
            "first_line": "8416 Konopelski Overpass",
            "second_line": "Suite 105",
            "state": "FL",
            "zip": "43257-6852"
          },
          "image": {
            "id": "533aa6dcf6f407fccf000398",
            "name": "Trinix",
            "index": 0,
            "description": "Voluptatibus ducimus odio quasi excepturi cupiditate quo.",
            "image_url": "\/system\/images\/images\/533a\/a6dc\/f6f4\/07fc\/cf00\/0398\/original\/200?1396352731"
          },
          "phones": [
            {
              "id": "533aa6dcf6f407fccf000399",
              "name": "Work",
              "number": "9016638219"
            }
          ]
        }
      }
      EOS
      def show
        respond_with Store.find(params[:id])
      end
      
      api :POST, "/stores", "Create a new store with given params"
      param_group :store
      error 422, "Unprocessable Entity"
      example <<-EOS
      {
        "store": {
          "description": "Dolor exercitationem beatae dolorem.",
          "legal": "Quia dolores repellat temporibus animi magnam inventore. Qui rerum aspernatur dolorem ea soluta sit qui impedit. Laboriosam deserunt et id maiores. Maxime blanditiis facilis quidem ab cupiditate eius doloribus modi.",
          "name": "Adams-Okuneva",
          "address_attributes": {
            "name": "Business",
            "city": "North Leopoldo",
            "country": "US",
            "first_line": "8416 Konopelski Overpass",
            "second_line": "Suite 105",
            "state": "FL",
            "zip": "43257-6852"
          },
          "image_attributes": {
            "name": "Trinix",
            "index": 0,
            "description": "Voluptatibus ducimus odio quasi excepturi cupiditate quo.",
            "image_url": "\/system\/images\/images\/533a\/a6dc\/f6f4\/07fc\/cf00\/0398\/original\/200?1396352731"
          },
          "phone_attributes": [
            {
              "id": "533aa6dcf6f407fccf000399",
              "name": "Work",
              "number": "9016638219"
            }
          ]
        }
      }
      EOS
      def create
        respond_with current_account.stores.create(params[:store])
      end
      
      api :PUT, "/stores/:id", "Update an store with given params"
      param :id, String, :required => true
      param_group :store
      error 404, "Not Found"
      error 422, "Unprocessable Entity"
      example <<-EOS
      {
        "store": {
          "description": "Dolor exercitationem beatae dolorem.",
          "legal": "Quia dolores repellat temporibus animi magnam inventore. Qui rerum aspernatur dolorem ea soluta sit qui impedit. Laboriosam deserunt et id maiores. Maxime blanditiis facilis quidem ab cupiditate eius doloribus modi.",
          "name": "Adams-Okuneva",
          "address_attributes": {
            "name": "Business",
            "city": "North Leopoldo",
            "country": "US",
            "first_line": "8416 Konopelski Overpass",
            "second_line": "Suite 105",
            "state": "FL",
            "zip": "43257-6852"
          },
          "image_attributes": {
            "name": "Trinix",
            "index": 0,
            "description": "Voluptatibus ducimus odio quasi excepturi cupiditate quo.",
            "image_url": "\/system\/images\/images\/533a\/a6dc\/f6f4\/07fc\/cf00\/0398\/original\/200?1396352731"
          },
          "phone_attributes": [
            {
              "id": "533aa6dcf6f407fccf000399",
              "name": "Work",
              "number": "9016638219"
            }
          ]
        }
      }
      EOS
      def update
        respond_with Store.find(params[:id]).update_attributes(params[:store])
      end
      
      api :DELETE, "/stores/:id", "Destroy store with given ID"
      param :id, String, :required => true
      error 404, "Not Found"
      example <<-EOS
        200 OK
      EOS
      def destroy
        respond_with Store.destroy(params[:id])
      end
    end
  end
end