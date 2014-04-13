module Api
  module V1
    class ItemsController < ApiController
      resource_description do
        short 'Items represent the catalog of all items for sale or purchase'
        formats ['JSON']
        api_base_url '/api'
      end
      
      def_param_group :item do
        param :item, Hash, :required => true, :action_aware => true do
          param :inventory_id, String, :required => true
          param :description, String
          param :identifier, String
          param :identifier_type, String
          param :manufacturer, String
          param :name, String
          param :price, Integer
          param :price_cash, Integer
          param :price_credit, Integer
          param :saleable, Boolean
          param :sku, String
          param :taxable, Boolean
          param :component_attributes, Array do
            param :adjustment, Float
            param :adjustment_percentage, Boolean
            param :adjustment_cash, Float
            param :adjustment_cash_percentage, Boolean
            param :adjustment_credit, Float
            param :adjustment_credit_percentage, Boolean
            param :description, String
            param :name, String
            param :typical, Boolean
          end
          param :condition_attributes, Array do
            param :adjustment, Float
            param :adjustment_percentage, Boolean
            param :adjustment_cash, Float
            param :adjustment_cash_percentage, Boolean
            param :adjustment_credit, Float
            param :adjustment_credit_percentage, Boolean
            param :description, String
            param :name, String
          end
          param :image_attributes, Array do
            param :name, String
            param :index, Integer
            param :description, String
            param :image_url, String
          end
          param :prop_attributes, Array do
            param :key, String
            param :value, String
          end
          param :tag_attributes, Array do
            param :name, String
          end
          param :variant_attributes, Array do
            param :adjustment, Float
            param :adjustment_percentage, Boolean
            param :adjustment_cash, Float
            param :adjustment_cash_percentage, Boolean
            param :adjustment_credit, Float
            param :adjustment_credit_percentage, Boolean
            param :description, String
            param :name, String
          end
        end
      end
      
      skip_filter :user_time_zone
      
      respond_to :json
      
      api :GET, "/items/", "Retrieve an array of items based on given filter params"
      param :search, String, :desc => "Full text query string for searching results"
      param :sort, String, :desc => "Property with which to sort results"
      param :order, ['ASC', 'DESC'], :desc => "Order in which to sort results (Default: ASC)"
      param :page, Integer, :desc => "The page number to return (Default: 1)"
      param :per_page, Integer, :desc => "The quantity of results per page (Default: 10)"
      param :inventory_id, String, :desc => "Filter results by inventory ID"
      param :components, Boolean, :desc => "Whether or not to include components in results"
      param :conditions, Boolean, :desc => "Whether or not to include conditions in results"
      param :inventory, Boolean, :desc => "Whether or not to include inventory in results"
      param :props, Boolean, :desc => "Whether or not to include properties in results"
      param :tags, Boolean, :desc => "Whether or not to include tags in results"
      param :variants, Boolean, :desc => "Whether or not to include variants in results"
      meta ['total', 'per_page', 'page']
      example <<-EOS
      {
        "items": [
          {
            "id": "533aa713f6f407fccf0004f9",
            "inventory_id": "533aa705f6f407fccf000465",
            "description": "Velit inventore voluptates pariatur et cupiditate expedita aut.",
            "identifier": "918535641",
            "identifier_type": "UPC-E",
            "manufacturer": "Brinceforge",
            "name": "Amnix Power System",
            "price": 9106,
            "price_cash": 5283,
            "price_credit": 8451,
            "saleable": true,
            "sku": "96AAF95A66EEE7D8",
            "taxable": true,
            "created_at": "2014-04-01T11:46:28Z",
            "updated_at": "2014-04-01T11:46:28Z",
            "images": [
              {
                "id": "533aa714f6f407fccf0004fc",
                "name": "Pyffewood",
                "index": 0,
                "description": "Qui ullam soluta vero est laboriosam molestias unde quae.",
                "image_url": "\/system\/images\/images\/533a\/a714\/f6f4\/07fc\/cf00\/04fc\/original\/200?1396352788"
              }
            ]
          },
          {
            "id": "533aa732f6f407fccf0005e8",
            "inventory_id": "533aa705f6f407fccf000487",
            "description": "Illo ullam at sit iste qui.",
            "identifier": "424577848",
            "identifier_type": "EAN-13",
            "manufacturer": "Onesche",
            "name": "Brerewood Power Remote Kit",
            "price": 4227,
            "price_cash": 2768,
            "price_credit": 43,
            "saleable": false,
            "sku": "D251C7EDF5A7C49B",
            "taxable": true,
            "created_at": "2014-04-01T11:47:00Z",
            "updated_at": "2014-04-01T11:47:00Z",
            "images": [
              {
                "id": "533aa734f6f407fccf0005f4",
                "name": "Tronce",
                "index": 0,
                "description": "Illum ipsum dolore quam quo eligendi quidem.",
                "image_url": "\/system\/images\/images\/533a\/a734\/f6f4\/07fc\/cf00\/05f4\/original\/200?1396352818"
              },
              {
                "id": "533aa734f6f407fccf0005f5",
                "name": "Amsync",
                "index": 0,
                "description": "Quia deserunt in accusamus temporibus quaerat assumenda aut.",
                "image_url": "\/system\/images\/images\/533a\/a734\/f6f4\/07fc\/cf00\/05f5\/original\/200?1396352819"
              },
              {
                "id": "533aa734f6f407fccf0005f6",
                "name": "TYC",
                "index": 0,
                "description": "Et eos nesciunt quae et ipsa tempora.",
                "image_url": "\/system\/images\/images\/533a\/a734\/f6f4\/07fc\/cf00\/05f6\/original\/200?1396352819"
              },
              {
                "id": "533aa734f6f407fccf0005f7",
                "name": "Capod",
                "index": 0,
                "description": "Esse voluptatem consequatur rerum ex repellat animi vitae illo.",
                "image_url": "\/system\/images\/images\/533a\/a734\/f6f4\/07fc\/cf00\/05f7\/original\/200?1396352820"
              }
            ]
          },
          ...
          {
            "id": "533aa754f6f407fccf000722",
            "inventory_id": "533aa705f6f407fccf000475",
            "description": "Et impedit odio quas tenetur maiores cumque dolor cupiditate.",
            "identifier": "520617699",
            "identifier_type": "EAN-8",
            "manufacturer": "Briephforge",
            "name": "Conix Gel Output Viewer",
            "price": 6508,
            "price_cash": 3709,
            "price_credit": 1254,
            "saleable": true,
            "sku": "43149B377E2B3CF0",
            "taxable": true,
            "created_at": "2014-04-01T11:47:34Z",
            "updated_at": "2014-04-01T11:47:34Z",
            "images": [
              {
                "id": "533aa756f6f407fccf00072b",
                "name": "Aquapod",
                "index": 0,
                "description": "Corporis maiores odit esse culpa perspiciatis.",
                "image_url": "\/system\/images\/images\/533a\/a756\/f6f4\/07fc\/cf00\/072b\/original\/200?1396352853"
              },
              {
                "id": "533aa756f6f407fccf00072c",
                "name": "Phiophforge",
                "index": 0,
                "description": "Et est voluptatibus voluptate.",
                "image_url": "\/system\/images\/images\/533a\/a756\/f6f4\/07fc\/cf00\/072c\/original\/200?1396352853"
              },
              {
                "id": "533aa756f6f407fccf00072d",
                "name": "Pheck",
                "index": 0,
                "description": "Architecto accusantium culpa accusamus magni vel qui et.",
                "image_url": "\/system\/images\/images\/533a\/a756\/f6f4\/07fc\/cf00\/072d\/original\/200?1396352854"
              }
            ]
          }
        ],
        "meta": {
          "total": 30,
          "per_page": 10,
          "page": 1
        }
      }
      EOS
      def index
        @items = Item.search(params[:search]).sorted(params[:sort], params[:order]).inventory_id(params[:inventory_id])
        @items = @items.paginate(:page => params[:page], :per_page => params[:per_page] == '0' ? @items.count : params[:per_page])
        @meta = { :total => @items.total_entries, :per_page => @items.per_page, :page => @items.current_page }
        
        respond_with @items, :each_serializer => ItemIndexSerializer, :meta => @meta
      end
      
      api :GET, "/items/:id", "Show item with given ID"
      param :id, String, :required => true
      error 404, "Not Found"
      example <<-EOS
      {
        "item": {
          "id": "533aa713f6f407fccf0004f9",
          "inventory_id": "533aa705f6f407fccf000465",
          "description": "Velit inventore voluptates pariatur et cupiditate expedita aut.",
          "identifier": "918535641",
          "identifier_type": "UPC-E",
          "manufacturer": "Brinceforge",
          "name": "Amnix Power System",
          "price": 9106,
          "price_cash": 5283,
          "price_credit": 8451,
          "saleable": true,
          "sku": "96AAF95A66EEE7D8",
          "taxable": true,
          "created_at": "2014-04-01T11:46:28Z",
          "updated_at": "2014-04-01T11:46:28Z",
          "components": [
            {
              "id": "533aa713f6f407fccf0004f8",
              "item_id": "533aa713f6f407fccf0004f9",
              "adjustment": 26.4074,
              "adjustment_percentage": false,
              "adjustment_cash": 61.9208,
              "adjustment_cash_percentage": false,
              "adjustment_credit": 58.2784,
              "adjustment_credit_percentage": false,
              "description": "Expedita totam ratione distinctio iste perspiciatis.",
              "name": "Output Performance Compressor",
              "typical": true
            }
          ],
          "conditions": [
            {
              "id": "533aa713f6f407fccf0004fa",
              "item_id": "533aa713f6f407fccf0004f9",
              "adjustment": -0.43,
              "adjustment_percentage": true,
              "adjustment_cash": -0.09,
              "adjustment_cash_percentage": true,
              "adjustment_credit": -0.85,
              "adjustment_credit_percentage": true,
              "description": "Quisquam nesciunt earum necessitatibus non.",
              "name": "Parts"
            }
          ],
          "images": [
            {
              "id": "533aa714f6f407fccf0004fc",
              "name": "Pyffewood",
              "index": 0,
              "description": "Qui ullam soluta vero est laboriosam molestias unde quae.",
              "image_url": "\/system\/images\/images\/533a\/a714\/f6f4\/07fc\/cf00\/04fc\/original\/200?1396352788"
            }
          ],
          "inventory": {
            "id": "533aa705f6f407fccf000465",
            "name": "Pheffe",
            "description": "Rerum nemo id voluptatem eum.",
            "created_at": "2014-04-01T11:46:13Z",
            "updated_at": "2014-04-01T11:46:13Z"
          },
          "props": [
            {
              "id": "533aa714f6f407fccf0004fd",
              "key": "Readymade",
              "value": "next level"
            }
          ],
          "tags": [
            {
              "id": "533aa714f6f407fccf0004fe",
              "name": "Keffiyeh"
            }
          ],
          "variants": [
            {
              "id": "533aa714f6f407fccf0004fb",
              "item_id": "533aa713f6f407fccf0004f9",
              "adjustment": 50.9936,
              "adjustment_percentage": false,
              "adjustment_cash": 26.4074,
              "adjustment_cash_percentage": false,
              "adjustment_credit": 51.9042,
              "adjustment_credit_percentage": false,
              "description": "Sunt quia maxime odit officia optio suscipit et.",
              "name": "W35",
              "identifier": null,
              "identifier_type": "UPC"
            }
          ]
        }
      }
      EOS
      def show
        respond_with Item.find(params[:id])
      end
      
      api :POST, "/items", "Create a new item with given params"
      param_group :item
      error 422, "Unprocessable Entity"
      example <<-EOS
      {
        "item": {
          "inventory_id": "533aa705f6f407fccf000465",
          "description": "Velit inventore voluptates pariatur et cupiditate expedita aut.",
          "identifier": "918535641",
          "identifier_type": "UPC-E",
          "manufacturer": "Brinceforge",
          "name": "Amnix Power System",
          "price": 9106,
          "price_cash": 5283,
          "price_credit": 8451,
          "saleable": true,
          "sku": "96AAF95A66EEE7D8",
          "taxable": true,
          "component_attributes": [
            {
              "adjustment": 26.4074,
              "adjustment_percentage": false,
              "adjustment_cash": 61.9208,
              "adjustment_cash_percentage": false,
              "adjustment_credit": 58.2784,
              "adjustment_credit_percentage": false,
              "description": "Expedita totam ratione distinctio iste perspiciatis.",
              "name": "Output Performance Compressor",
              "typical": true
            }
          ],
          "condition_attributes": [
            {
              "adjustment": -0.43,
              "adjustment_percentage": true,
              "adjustment_cash": -0.09,
              "adjustment_cash_percentage": true,
              "adjustment_credit": -0.85,
              "adjustment_credit_percentage": true,
              "description": "Quisquam nesciunt earum necessitatibus non.",
              "name": "Parts"
            }
          ],
          "image_attributes": [
            {
              "name": "Pyffewood",
              "index": 0,
              "description": "Qui ullam soluta vero est laboriosam molestias unde quae.",
              "image_url": "\/system\/images\/images\/533a\/a714\/f6f4\/07fc\/cf00\/04fc\/original\/200?1396352788"
            }
          ],
          "prop_attributes": [
            {
              "key": "Readymade",
              "value": "next level"
            }
          ],
          "tag_attributes": [
            {
              "name": "Keffiyeh"
            }
          ],
          "variant_attributes": [
            {
              "adjustment": 50.9936,
              "adjustment_percentage": false,
              "adjustment_cash": 26.4074,
              "adjustment_cash_percentage": false,
              "adjustment_credit": 51.9042,
              "adjustment_credit_percentage": false,
              "description": "Sunt quia maxime odit officia optio suscipit et.",
              "name": "W35",
              "identifier": null,
              "identifier_type": "UPC"
            }
          ]
        }
      }
      EOS
      def create
        respond_with current_account.items.create(params[:item])
      end
      
      api :PUT, "/items/:id", "Update an item with given params"
      param :id, String, :required => true
      param_group :item
      error 404, "Not Found"
      error 422, "Unprocessable Entity"
      example <<-EOS
      {
        "item": {
          "inventory_id": "533aa705f6f407fccf000465",
          "description": "Velit inventore voluptates pariatur et cupiditate expedita aut.",
          "identifier": "918535641",
          "identifier_type": "UPC-E",
          "manufacturer": "Brinceforge",
          "name": "Amnix Power System",
          "price": 9106,
          "price_cash": 5283,
          "price_credit": 8451,
          "saleable": true,
          "sku": "96AAF95A66EEE7D8",
          "taxable": true,
          "component_attributes": [
            {
              "adjustment": 26.4074,
              "adjustment_percentage": false,
              "adjustment_cash": 61.9208,
              "adjustment_cash_percentage": false,
              "adjustment_credit": 58.2784,
              "adjustment_credit_percentage": false,
              "description": "Expedita totam ratione distinctio iste perspiciatis.",
              "name": "Output Performance Compressor",
              "typical": true
            }
          ],
          "condition_attributes": [
            {
              "adjustment": -0.43,
              "adjustment_percentage": true,
              "adjustment_cash": -0.09,
              "adjustment_cash_percentage": true,
              "adjustment_credit": -0.85,
              "adjustment_credit_percentage": true,
              "description": "Quisquam nesciunt earum necessitatibus non.",
              "name": "Parts"
            }
          ],
          "image_attributes": [
            {
              "name": "Pyffewood",
              "index": 0,
              "description": "Qui ullam soluta vero est laboriosam molestias unde quae.",
              "image_url": "\/system\/images\/images\/533a\/a714\/f6f4\/07fc\/cf00\/04fc\/original\/200?1396352788"
            }
          ],
          "prop_attributes": [
            {
              "key": "Readymade",
              "value": "next level"
            }
          ],
          "tag_attributes": [
            {
              "name": "Keffiyeh"
            }
          ],
          "variant_attributes": [
            {
              "adjustment": 50.9936,
              "adjustment_percentage": false,
              "adjustment_cash": 26.4074,
              "adjustment_cash_percentage": false,
              "adjustment_credit": 51.9042,
              "adjustment_credit_percentage": false,
              "description": "Sunt quia maxime odit officia optio suscipit et.",
              "name": "W35",
              "identifier": null,
              "identifier_type": "UPC"
            }
          ]
        }
      }
      EOS
      def update
        respond_with Item.find(params[:id]).update_attributes(params[:item])
      end
      
      api :DELETE, "/items/:id", "Destroy item with given ID"
      param :id, String, :required => true
      error 404, "Not Found"
      example <<-EOS
        200 OK
      EOS
      def destroy
        respond_with Item.destroy(params[:id])
      end
    end
  end
end