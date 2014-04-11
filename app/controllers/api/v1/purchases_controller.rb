module Api
  module V1
    class PurchasesController < ApiController
      resource_description do
        short 'Purchases represent transactions where customers buy in items'
        formats ['JSON']
        api_base_url '/api/v1'
      end

      def_param_group :purchase do
        param :purchase, Hash, :repaired => true, :action_aware => true do
          param :customer_id, String
          param :store_id, String, :required => true
          param :till_id, String, :required => true
          param :user_id, String, :required => true
          param :complete, Boolean
          param :flagged, Boolean
          param :note, String
          param :sku, String
          param :tax_rate, Float
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
        end
      end
      
      skip_filter :user_time_zone
      
      respond_to :json
      
      api :GET, "/sales/", "Retrieve an array of sales based on given filter params"
      param :search, String, :desc => "Full text query string for searching results"
      param :sort, String, :desc => "Property with which to sort results"
      param :order, ['ASC', 'DESC'], :desc => "Order in which to sort results (Default: ASC)"
      param :page, Integer, :desc => "The page number to return (Default: 1)"
      param :per_page, Integer, :desc => "The quantity of results per page (Default: 10)"
      param :certificate, Boolean, :desc => "Include certificate in results"
      param :customer, Boolean, :desc => "Include customer in results"
      param :lines, Boolean, :desc => "Include lines in results"
      param :store, Boolean, :desc => "Include store in results"
      param :till, Boolean, :desc => "Include till in results"
      param :user, Boolean, :desc => "Include user in results"
      param :user_id, String, :desc => "Filter results by user ID"
      param :customer_id, String, :desc => "Filter results by customer ID"
      param :till_id, String, :desc => "Filter results by till ID"
      param :store_id, String, :desc => "Filter results by store ID"
      meta ['total', 'per_page', 'page']
      example <<-EOS
      {
        "purchases": [
          {
            "id": "533aa8acf6f407131b000001",
            "customer_id": "533aa6aff6f407fccf00023f",
            "store_id": "533aa6caf6f407fccf0002f5",
            "till_id": "533aa705f6f407fccf000444",
            "user_id": "533aa62ff6f407fccf000002",
            "complete": false,
            "flagged": false,
            "sku": "DFD04EA370CC58E8",
            "note": "",
            "ratio": 0,
            "credit_balance": 0,
            "completed_at": null,
            "created_at": "2014-04-01T11:53:16Z",
            "updated_at": "2014-04-01T11:53:16Z"
          },
          {
            "id": "533aa759f6f407fccf0007c3",
            "customer_id": null,
            "store_id": "533aa6cef6f407fccf00031e",
            "till_id": "533aa705f6f407fccf000428",
            "user_id": "533aa631f6f407fccf000019",
            "complete": true,
            "flagged": true,
            "sku": "C1187F3C6998B8CD",
            "note": "Repellat explicabo rerum cumque qui sunt.",
            "ratio": 0.88541831079364,
            "credit_balance": 0,
            "completed_at": "2014-03-29T20:48:38Z",
            "created_at": "2014-04-01T11:47:37Z",
            "updated_at": "2014-04-01T11:48:38Z"
          },
          ...
          {
            "id": "533aa758f6f407fccf000792",
            "customer_id": "533aa6a5f6f407fccf000220",
            "store_id": "533aa6d9f6f407fccf00037e",
            "till_id": "533aa705f6f407fccf000424",
            "user_id": "533aa62ff6f407fccf000002",
            "complete": true,
            "flagged": false,
            "sku": "4FF150D66E6E05FC",
            "note": "Rerum quidem quis sunt placeat.",
            "ratio": 0.11299974063242,
            "credit_balance": 0,
            "completed_at": "2014-03-31T11:48:38Z",
            "created_at": "2014-04-01T11:47:36Z",
            "updated_at": "2014-04-01T11:48:38Z"
          }
        ],
        "meta": {
          "total": 49,
          "per_page": 10,
          "page": 1
        }
      }
      EOS
      def index
        @purchases = Purchase.search(params[:search])
        @purchases = @purchases.customer_id(params[:customer_id]).user_id(params[:user_id]).till_id(params[:till_id]).store_id(params[:store_id])
        @purchases = @purchases.sorted(params[:sort], params[:order])
        @purchases = @purchases.paginate(:page => params[:page], :per_page => params[:per_page] == '0' ? @purchases.count : params[:per_page])
        @meta = { :total => @purchases.total_entries, :per_page => @purchases.per_page, :page => @purchases.current_page }
        
        respond_with @purchases, :each_serializer => PurchaseIndexSerializer, :meta => @meta
      end
      
      api :GET, "/purchases/:id", "Show purchase with given ID"
      param :id, String, :required => true
      error 404, "Not Found"
      example <<-EOS
      {
        "purchase": {
          "id": "533aa8acf6f407131b000001",
          "customer_id": "533aa6aff6f407fccf00023f",
          "store_id": "533aa6caf6f407fccf0002f5",
          "till_id": "533aa705f6f407fccf000444",
          "user_id": "533aa62ff6f407fccf000002",
          "complete": false,
          "flagged": false,
          "sku": "DFD04EA370CC58E8",
          "note": "",
          "ratio": 0,
          "credit_balance": 0,
          "completed_at": null,
          "created_at": "2014-04-01T11:53:16Z",
          "updated_at": "2014-04-01T11:53:16Z",
          "customer": {...},
          "lines": [
            {
              "id": "533aa8acf6f407131b000002",
              "certificate_id": null,
              "unit_id": "533aa713f6f407fccf0004e3",
              "item_id": "533aa713f6f407fccf0004f9",
              "amount": 0,
              "amount_cash": 7923,
              "amount_credit": 13641,
              "bullets": [
                "Output Performance Compressor",
                "Parts"
              ],
              "note": "",
              "quantity": 1,
              "sku": "96AAF95A66EEE7D8",
              "taxable": true,
              "title": "Amnix Power System",
              "unit": {...},
              "item": {...},
              "certificate": {...}
            }
          ],
          "store": {...},
          "till": {...},
          "user": {...}
        }
      }
      EOS
      def show
        respond_with Purchase.find(params[:id])
      end
      
      api :POST, "/purchases", "Create a new purchase with given params"
      param_group :purchase
      error 422, "Unprocessable Entity"
      example <<-EOS
      {
        "purchase": {
          "customer_id": "533aa6aff6f407fccf00023f",
          "store_id": "533aa6caf6f407fccf0002f5",
          "till_id": "533aa705f6f407fccf000444",
          "user_id": "533aa62ff6f407fccf000002",
          "complete": false,
          "flagged": false,
          "sku": "DFD04EA370CC58E8",
          "note": "",
          "ratio": 0,
          "credit_balance": 0,
          "lines": [
            {
              "id": "533aa8acf6f407131b000002",
              "certificate_id": null,
              "unit_id": "533aa713f6f407fccf0004e3",
              "item_id": "533aa713f6f407fccf0004f9",
              "amount": 0,
              "amount_cash": 7923,
              "amount_credit": 13641,
              "bullets": [
                "Output Performance Compressor",
                "Parts"
              ],
              "note": "",
              "quantity": 1,
              "sku": "96AAF95A66EEE7D8",
              "taxable": true,
              "title": "Amnix Power System"
            }
          ]
        }
      }
      EOS
      def create
        respond_with current_account.purchases.create(params[:purchase])
      end
      
      api :PUT, "/purchases/:id", "Update an purchase with given params"
      param :id, String, :required => true
      param_group :purchase
      error 404, "Not Found"
      error 422, "Unprocessable Entity"
      example <<-EOS
      {
        "purchase": {
          "customer_id": "533aa6aff6f407fccf00023f",
          "store_id": "533aa6caf6f407fccf0002f5",
          "till_id": "533aa705f6f407fccf000444",
          "user_id": "533aa62ff6f407fccf000002",
          "complete": false,
          "flagged": false,
          "sku": "DFD04EA370CC58E8",
          "note": "",
          "ratio": 0,
          "credit_balance": 0,
          "lines": [
            {
              "id": "533aa8acf6f407131b000002",
              "certificate_id": null,
              "unit_id": "533aa713f6f407fccf0004e3",
              "item_id": "533aa713f6f407fccf0004f9",
              "amount": 0,
              "amount_cash": 7923,
              "amount_credit": 13641,
              "bullets": [
                "Output Performance Compressor",
                "Parts"
              ],
              "note": "",
              "quantity": 1,
              "sku": "96AAF95A66EEE7D8",
              "taxable": true,
              "title": "Amnix Power System"
            }
          ]
        }
      }
      EOS
      def update
        respond_with Purchase.find(params[:id]).update_attributes(params[:purchase])
      end
      
      api :DELETE, "/purchases/:id", "Destroy purchase with given ID"
      param :id, String, :required => true
      error 404, "Not Found"
      example <<-EOS
        200 OK
      EOS
      def destroy
        respond_with Purchase.destroy(params[:id])
      end
    end
  end
end