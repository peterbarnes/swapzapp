module Api
  module V1
    class RepairsController < ApiController
      resource_description do
        short 'Repairs represent transactions where customers have things repaired'
        formats ['JSON']
        api_base_url '/api'
      end
      
      def_param_group :repair do
        param :repair, Hash, :repaired => true, :action_aware => true do
          param :certificate_id, String
          param :customer_id, String
          param :location_id, String
          param :store_id, String, :required => true
          param :till_id, String, :required => true
          param :user_id, String, :required => true
          param :complete, Boolean
          param :flagged, Boolean
          param :identifier, String
          param :identifier_type, String
          param :note, String
          param :symptoms, String
          param :sku, String
          param :tax_rate, Float
          param :image_attributes, Array do
            param :name, String
            param :index, Integer
            param :description, String
            param :image_url, String
          end
          param :lines_attributes, Array do
            param :certificate_id, String
            param :unit_id, String
            param :item_id, String
            param :amount, Integer
            param :amount_cash, Integer
            param :amount_credit, Integer
            param :bullets, Array
            param :note, String
            param :quantity, Integer
            param :sku, String
            param :taxable, Boolean
            param :title, String
          end
          param :logs_attributes, Array do
            param :user_id, String
            param :name, String
            param :note, String
          end
          param :payment_attributes, Array do
            param :cash, Integer
            param :check, Integer
            param :credit, Integer
            param :gift_card, Integer
            param :store_credit, Integer
          end
        end
      end
      
      skip_filter :user_time_zone
      
      respond_to :json
      
      api :GET, "/repairs/", "Retrieve an array of repairs based on given filter params"
      param :search, String, :desc => "Full text query string for searching results"
      param :sort, String, :desc => "Property with which to sort results"
      param :order, ['ASC', 'DESC'], :desc => "Order in which to sort results (Default: ASC)"
      param :page, Integer, :desc => "The page number to return (Default: 1)"
      param :per_page, Integer, :desc => "The quantity of results per page (Default: 10)"
      param :certificate, Boolean, :desc => "Include certificate in results"
      param :customer, Boolean, :desc => "Include customer in results"
      param :lines, Boolean, :desc => "Include lines in results"
      param :location, Boolean, :desc => "Include location in results"
      param :logs, Boolean, :desc => "Include logs in results"
      param :store, Boolean, :desc => "Include store in results"
      param :till, Boolean, :desc => "Include till in results"
      param :user, Boolean, :desc => "Include user in results"
      param :user_id, String, :desc => "Filter results by user ID"
      param :customer_id, String, :desc => "Filter results by customer ID"
      param :location_id, String, :desc => "Filter results by location ID"
      param :store_id, String, :desc => "Filter results by store ID"
      meta ['total', 'per_page', 'page']
      example <<-EOS
      {
        "repairs": [
          {
            "id": "533aa77cf6f407fccf0008b2",
            "certificate_id": "533aa786f6f407fccf0008e6",
            "customer_id": "533aa6aff6f407fccf00023f",
            "location_id": "533aa6f4f6f407fccf0003ea",
            "store_id": "533aa6d6f6f407fccf000361",
            "till_id": "533aa705f6f407fccf00043e",
            "user_id": "533aa631f6f407fccf000017",
            "complete": true,
            "flagged": false,
            "identifier": "691564282",
            "identifier_type": "Serial",
            "note": "Illum quod minima ratione sit perspiciatis.",
            "symptoms": "Quia repudiandae quae doloribus quos animi aut. Mollitia eum asperiores ea quos quis iusto. Asperiores eos repellat dolorem quod exercitationem deleniti dicta.",
            "sku": "7EC889004C23E72C",
            "tax": 2873,
            "tax_rate": 0.07,
            "completed_at": "2014-03-28T20:48:40Z",
            "created_at": "2014-04-01T11:48:15Z",
            "updated_at": "2014-04-01T11:48:40Z",
            "images": [...],
            "payment": {
              "_id": "533aa77ff6f407fccf0008bf",
              "cash": 1958,
              "check": 6759,
              "credit": 1990,
              "gift_card": 3725,
              "store_credit": 6326
            }
          },
          {
            "id": "533aa786f6f407fccf0008e6",
            "certificate_id": "533aa786f6f407fccf0008e6",
            "customer_id": "533aa64af6f407fccf00008c",
            "location_id": "533aa6f3f6f407fccf0003e6",
            "store_id": "533aa6d0f6f407fccf000331",
            "till_id": "533aa705f6f407fccf000444",
            "user_id": "533aa630f6f407fccf000009",
            "complete": true,
            "flagged": false,
            "identifier": "221974656",
            "identifier_type": "Serial",
            "note": "Iusto dolorum magni hic fuga nostrum aliquam et.",
            "symptoms": "Architecto animi magni molestias quos pariatur ipsum. Magni aut cumque et libero praesentium omnis perspiciatis dolorum. Eos impedit ex illo earum ab aut praesentium.",
            "sku": "C286263DF96523D6",
            "tax": 929,
            "tax_rate": 0.05,
            "completed_at": "2014-03-30T03:48:40Z",
            "created_at": "2014-04-01T11:48:23Z",
            "updated_at": "2014-04-01T11:48:40Z",
            "images": [...],
            "payment": {
              "_id": "533aa787f6f407fccf0008ed",
              "cash": 4328,
              "check": 949,
              "credit": 2665,
              "gift_card": 2874,
              "store_credit": 3730
            }
          },
          ...
          {
            "id": "533aa789f6f407fccf0008f9",
            "certificate_id": "533aa786f6f407fccf0008e6",
            "customer_id": "533aa6c3f6f407fccf000299",
            "location_id": "533aa6fff6f407fccf000408",
            "store_id": "533aa6cbf6f407fccf0002fd",
            "till_id": "533aa705f6f407fccf000420",
            "user_id": "533aa631f6f407fccf000010",
            "complete": true,
            "flagged": false,
            "identifier": "966299909",
            "identifier_type": "Serial",
            "note": "Alias est quod blanditiis nobis.",
            "symptoms": "Et similique perferendis alias qui doloremque fugiat. Libero architecto occaecati cupiditate ut vero quia. Blanditiis dignissimos quo cum delectus cumque ut quaerat et. Labore eligendi quia natus nulla. Maxime error cumque aspernatur est sunt minima laboriosam.",
            "sku": "8E6E73A61450BC01",
            "tax": 102,
            "tax_rate": 0.01,
            "completed_at": "2014-03-27T00:48:40Z",
            "created_at": "2014-04-01T11:48:27Z",
            "updated_at": "2014-04-01T11:48:40Z",
            "images": [...],
            "payment": {
              "_id": "533aa78bf6f407fccf000900",
              "cash": 1544,
              "check": 1883,
              "credit": 1517,
              "gift_card": 5629,
              "store_credit": 8820
            }
          }
        ],
        "meta": {
          "total": 36,
          "per_page": 10,
          "page": 1
        }
      }
      EOS
      def index
        @repairs = Repair.search(params[:search])
        @repairs = @repairs.user_id(params[:user_id]).customer_id(params[:customer_id]).location_id(params[:location_id]).store_id(params[:store_id])
        @repairs = @repairs.sorted(params[:sort], params[:order])
        @repairs = @repairs.paginate(:page => params[:page], :per_page => params[:per_page] == '0' ? @repairs.count : params[:per_page] ||= 10)
        @meta = { :total => @repairs.total_entries, :per_page => @repairs.per_page, :page => @repairs.current_page }
        
        respond_with @repairs, :each_serializer => RepairIndexSerializer, :meta => @meta
      end
      
      api :GET, "/repairs/:id", "Show repair with given ID"
      param :id, String, :required => true
      param :customer, Boolean, :desc => "Include customer in result"
      error 404, "Not Found"
      example <<-EOS
      {
        "repair": {
          "id": "533aa77cf6f407fccf0008b2",
          "certificate_id": "533aa62ff6f407fccf000002",
          "customer_id": "533aa6aff6f407fccf00023f",
          "location_id": "533aa6f4f6f407fccf0003ea",
          "store_id": "533aa6d6f6f407fccf000361",
          "till_id": "533aa705f6f407fccf00043e",
          "user_id": "533aa631f6f407fccf000017",
          "complete": true,
          "flagged": false,
          "identifier": "691564282",
          "identifier_type": "Serial",
          "note": "Illum quod minima ratione sit perspiciatis.",
          "symptoms": "Quia repudiandae quae doloribus quos animi aut. Mollitia eum asperiores ea quos quis iusto. Asperiores eos repellat dolorem quod exercitationem deleniti dicta.",
          "sku": "7EC889004C23E72C",
          "tax": 2873,
          "tax_rate": 0.07,
          "completed_at": "2014-03-28T20:48:40Z",
          "created_at": "2014-04-01T11:48:15Z",
          "updated_at": "2014-04-01T11:48:40Z",
          "images": [...],
          "lines": [
            {
              "id": "533aa77ff6f407fccf0008b7",
              "certificate_id": null,
              "unit_id": null,
              "item_id": "533aa735f6f407fccf000608",
              "amount": 3976,
              "amount_cash": 129,
              "amount_credit": 1758,
              "bullets": [
                "Side Portable Filter",
                "Disc Transmitter",
                "Performance Controller",
                "Power Digital Compressor"
              ],
              "note": "Provident quam quos praesentium rerum modi.",
              "quantity": 7,
              "sku": "0B79DCC5AA5D950C",
              "taxable": true,
              "title": "Trist Audible Mount",
              "unit": {...},
              "item": {...},
              "certificate": null
            }
          ],
          "location": {...},
          "logs": [
            {
              "id": "533aa77ff6f407fccf0008bb",
              "user_id": "533aa631f6f407fccf00001b",
              "name": "Received",
              "note": "Pariatur enim optio est deserunt magni dolores odio et.",
              "created_at": "2014-04-01T11:48:15Z",
              "updated_at": "2014-04-01T11:48:15Z",
              "user": {...}
            }
          ],
          "payment": {
            "_id": "533aa77ff6f407fccf0008bf",
            "cash": 1958,
            "check": 6759,
            "credit": 1990,
            "gift_card": 3725,
            "store_credit": 6326
          },
          "store": {...},
          "till": {...},
          "user": {...}
        }
      }
      EOS
      def show
        respond_with Repair.find(params[:id])
      end
      
      api :POST, "/repairs", "Create a new repair with given params"
      param_group :repair
      error 422, "Unprocessable Entity"
      example <<-EOS
      {
        "repair": {
          "certificate_id": "533aa6aff6f407fccf00044a",
          "customer_id": "533aa6aff6f407fccf00023f",
          "location_id": "533aa6f4f6f407fccf0003ea",
          "store_id": "533aa6d6f6f407fccf000361",
          "till_id": "533aa705f6f407fccf00043e",
          "user_id": "533aa631f6f407fccf000017",
          "complete": true,
          "flagged": false,
          "identifier": "691564282",
          "identifier_type": "Serial",
          "note": "Illum quod minima ratione sit perspiciatis.",
          "symptoms": "Quia repudiandae quae doloribus quos animi aut. Mollitia eum asperiores ea quos quis iusto. Asperiores eos repellat dolorem quod exercitationem deleniti dicta.",
          "sku": "7EC889004C23E72C",
          "tax_rate": 0.07,
          "image_attributes": [...],
          "lines_attributes": [
            {
              "certificate_id": null,
              "unit_id": null,
              "item_id": "533aa735f6f407fccf000608",
              "amount": 3976,
              "amount_cash": 129,
              "amount_credit": 1758,
              "bullets": [
                "Side Portable Filter",
                "Disc Transmitter",
                "Performance Controller",
                "Power Digital Compressor"
              ],
              "note": "Provident quam quos praesentium rerum modi.",
              "quantity": 7,
              "sku": "0B79DCC5AA5D950C",
              "taxable": true,
              "title": "Trist Audible Mount"
            }
          ],
          "logs_attributes": [
            {
              "user_id": "533aa631f6f407fccf00001b",
              "name": "Received",
              "note": "Pariatur enim optio est deserunt magni dolores odio et."
            }
          ],
          "payment_attributes": {
            "cash": 1958,
            "check": 6759,
            "credit": 1990,
            "gift_card": 3725,
            "store_credit": 6326
          }
        }
      }
      EOS
      def create
        respond_with current_account.repairs.create(params[:repair])
      end
      
      api :PUT, "/repairs/:id", "Update an repair with given params"
      param :id, String, :required => true
      param_group :repair
      error 404, "Not Found"
      error 422, "Unprocessable Entity"
      example <<-EOS
      {
        "repair": {
          "certificate_id": "533aa6aff6f407fccf00044a",
          "customer_id": "533aa6aff6f407fccf00023f",
          "location_id": "533aa6f4f6f407fccf0003ea",
          "store_id": "533aa6d6f6f407fccf000361",
          "till_id": "533aa705f6f407fccf00043e",
          "user_id": "533aa631f6f407fccf000017",
          "complete": true,
          "flagged": false,
          "identifier": "691564282",
          "identifier_type": "Serial",
          "note": "Illum quod minima ratione sit perspiciatis.",
          "symptoms": "Quia repudiandae quae doloribus quos animi aut. Mollitia eum asperiores ea quos quis iusto. Asperiores eos repellat dolorem quod exercitationem deleniti dicta.",
          "sku": "7EC889004C23E72C",
          "tax_rate": 0.07,
          "image_attributes": [...],
          "lines_attributes": [
            {
              "certificate_id": null,
              "unit_id": null,
              "item_id": "533aa735f6f407fccf000608",
              "amount": 3976,
              "amount_cash": 129,
              "amount_credit": 1758,
              "bullets": [
                "Side Portable Filter",
                "Disc Transmitter",
                "Performance Controller",
                "Power Digital Compressor"
              ],
              "note": "Provident quam quos praesentium rerum modi.",
              "quantity": 7,
              "sku": "0B79DCC5AA5D950C",
              "taxable": true,
              "title": "Trist Audible Mount"
            }
          ],
          "logs_attributes": [
            {
              "user_id": "533aa631f6f407fccf00001b",
              "name": "Received",
              "note": "Pariatur enim optio est deserunt magni dolores odio et."
            }
          ],
          "payment_attributes": {
            "cash": 1958,
            "check": 6759,
            "credit": 1990,
            "gift_card": 3725,
            "store_credit": 6326
          }
        }
      }
      EOS
      def update
        respond_with Repair.find(params[:id]).update_attributes(params[:repair])
      end
      
      api :DELETE, "/repairs/:id", "Destroy repair with given ID"
      param :id, String, :required => true
      error 404, "Not Found"
      example <<-EOS
        200 OK
      EOS
      def destroy
        respond_with Repair.destroy(params[:id])
      end
    end
  end
end