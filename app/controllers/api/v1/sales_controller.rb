module Api
  module V1
    class SalesController < ApiController
      resource_description do
        short 'Sales represent transactions where customers buy items from the store'
        formats ['JSON']
        api_base_url '/api'
      end
      
      def_param_group :sale do
        param :sale, Hash, :repaired => true, :action_aware => true do
          param :certificate_id, String
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
      
      api :GET, "/sales/", "Retrieve an array of sales based on given filter params"
      param :search, String, :desc => "Full text query string for searching results"
      param :sort, String, :desc => "Property with which to sort results"
      param :order, ['ASC', 'DESC'], :desc => "Order in which to sort results (Default: ASC)"
      param :page, Integer, :desc => "The page number to return (Default: 1)"
      param :per_page, Integer, :desc => "The quantity of results per page (Default: 10)"
      param :certificate, Boolean, :desc => "Include certificate in results"
      param :customer, Boolean, :desc => "Include customer in results"
      param :lines, Boolean, :desc => "Include lines in results"
      param :payment, Boolean, :desc => "Include payment in results"
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
        "sales": [
          {
            "id": "5342b0c3f6f407c201000005",
            "certificate_id": "533aa786f6f407fccf0008e6",
            "customer_id": "533aa6aff6f407fccf00023f",
            "store_id": "533aa6dbf6f407fccf000392",
            "till_id": "533aa705f6f407fccf000430",
            "user_id": "533aa62ff6f407fccf000002",
            "complete": true,
            "flagged": false,
            "sku": "333296BF9A31A16D",
            "note": "",
            "tax_rate": 0.075,
            "credit_balance": 2662,
            "completed_at": "2014-04-07T14:05:55Z",
            "created_at": "2014-04-07T14:05:55Z",
            "updated_at": "2014-04-07T14:05:55Z"
          },
          {
            "id": "5342b05cf6f407c201000001",
            "certificate_id": "533aa786f6f407fccf0008e6",
            "customer_id": "533aa6aff6f407fccf00023f",
            "store_id": "533aa6dbf6f407fccf000392",
            "till_id": "533aa705f6f407fccf000430",
            "user_id": "533aa62ff6f407fccf000002",
            "complete": true,
            "flagged": false,
            "sku": "FFC39C70441A76C4",
            "note": "",
            "tax_rate": 0.075,
            "credit_balance": 2662,
            "completed_at": "2014-04-07T14:04:12Z",
            "created_at": "2014-04-07T14:04:12Z",
            "updated_at": "2014-04-07T14:04:12Z"
          },
          ...
          {
            "id": "533aa794f6f407fccf000998",
            "certificate_id": "533aa6c6f6f407fccf0002cb",
            "customer_id": null,
            "store_id": "533aa6d8f6f407fccf00037a",
            "till_id": "533aa705f6f407fccf000450",
            "user_id": "533aa632f6f407fccf00001d",
            "complete": true,
            "flagged": true,
            "sku": "8457C18E5E958C23",
            "note": "Rerum esse quia quibusdam.",
            "tax_rate": 0.05,
            "credit_balance": 0,
            "completed_at": "2014-03-31T09:48:39Z",
            "created_at": "2014-04-01T11:48:36Z",
            "updated_at": "2014-04-01T11:48:39Z"
          }
        ],
        "meta": {
          "total": 46,
          "per_page": 10,
          "page": 1
        }
      }
      EOS
      def index
        @sales = Sale.searched(params[:search])
        @sales = @sales.customer_id(params[:customer_id]).user_id(params[:user_id]).till_id(params[:till_id]).store_id(params[:store_id])
        @sales = @sales.sorted(params[:sort], params[:order])
        @sales = @sales.paginate(:page => params[:page], :per_page => params[:per_page] == '0' ? @sales.count : params[:per_page])
        @meta = { :total => @sales.total_entries, :per_page => @sales.per_page, :page => @sales.current_page }
        
        respond_with @sales, :each_serializer => SaleIndexSerializer, :meta => @meta
      end
      
      api :GET, "/sales/:id", "Show sale with given ID"
      param :id, String, :required => true
      error 404, "Not Found"
      example <<-EOS
      {
        "sale": {
          "id": "5342b0c3f6f407c201000005",
          "certificate_id": "533aa62ff6f407fccf000002",
          "customer_id": "533aa6aff6f407fccf00023f",
          "store_id": "533aa6dbf6f407fccf000392",
          "till_id": "533aa705f6f407fccf000430",
          "user_id": "533aa62ff6f407fccf000002",
          "complete": true,
          "flagged": false,
          "sku": "333296BF9A31A16D",
          "note": "",
          "tax_rate": 0.075,
          "credit_balance": 2662,
          "completed_at": "2014-04-07T14:05:55Z",
          "created_at": "2014-04-07T14:05:55Z",
          "updated_at": "2014-04-07T14:05:55Z",
          "certificate": null,
          "customer": {...},
          "lines": [
            {
              "id": "5342b0c3f6f407c201000006",
              "certificate_id": null,
              "unit_id": null,
              "item_id": "533aa732f6f407fccf0005e8",
              "amount": 4227,
              "amount_cash": 0,
              "amount_credit": 0,
              "bullets": [
                "Gel System",
                "Air Filter",
                "Remote Amplifier",
                "Power Compressor"
              ],
              "note": "",
              "quantity": 1,
              "sku": "D251C7EDF5A7C49B",
              "taxable": true,
              "title": "Brerewood Power Remote Kit",
              "unit": null,
              "item": {...},
              "certificate": null
            }
          ],
          "payment": {
            "_id": "5342b0c3f6f407c201000007",
            "cash": 0,
            "check": 4544,
            "credit": 0,
            "gift_card": 0,
            "store_credit": 0
          },
          "store": {...},
          "till": {...},
          "user": {...}
        }
      }
      EOS
      def show
        respond_with Sale.find(params[:id])
      end
      
      api :POST, "/sales", "Create a new sale with given params"
      param_group :sale
      error 422, "Unprocessable Entity"
      example <<-EOS
      {
        "sale": {
          "certificate_id": "533aa6aff6f407fccf00044a",
          "customer_id": "533aa6aff6f407fccf00023f",
          "store_id": "533aa6dbf6f407fccf000392",
          "till_id": "533aa705f6f407fccf000430",
          "user_id": "533aa62ff6f407fccf000002",
          "complete": true,
          "flagged": false,
          "sku": "333296BF9A31A16D",
          "note": "",
          "tax_rate": 0.075,
          "lines": [
            {
              "certificate_id": "533aa6aff6f407fccf00044a",
              "unit_id": "533aa6aff6f407fccf00042b",
              "item_id": "533aa732f6f407fccf0005e8",
              "amount": 4227,
              "amount_cash": 0,
              "amount_credit": 0,
              "bullets": [
                "Gel System",
                "Air Filter",
                "Remote Amplifier",
                "Power Compressor"
              ],
              "note": "",
              "quantity": 1,
              "sku": "D251C7EDF5A7C49B",
              "taxable": true,
              "title": "Brerewood Power Remote Kit"
            }
          ],
          "payment": {
            "cash": 0,
            "check": 4544,
            "credit": 0,
            "gift_card": 0,
            "store_credit": 0
          }
        }
      }
      EOS
      def create
        respond_with current_account.sales.create(params[:sale])
      end
      
      api :PUT, "/sales/:id", "Update an sale with given params"
      param :id, String, :required => true
      param_group :sale
      error 404, "Not Found"
      error 422, "Unprocessable Entity"
      example <<-EOS
      {
        "sale": {
          "certificate_id": "533aa6aff6f407fccf00044a",
          "customer_id": "533aa6aff6f407fccf00023f",
          "store_id": "533aa6dbf6f407fccf000392",
          "till_id": "533aa705f6f407fccf000430",
          "user_id": "533aa62ff6f407fccf000002",
          "complete": true,
          "flagged": false,
          "sku": "333296BF9A31A16D",
          "note": "",
          "tax_rate": 0.075,
          "lines": [
            {
              "certificate_id": "533aa6aff6f407fccf00042b",
              "unit_id": "533aa6aff6f407fccf00043c",
              "item_id": "533aa732f6f407fccf0005e8",
              "amount": 4227,
              "amount_cash": 0,
              "amount_credit": 0,
              "bullets": [
                "Gel System",
                "Air Filter",
                "Remote Amplifier",
                "Power Compressor"
              ],
              "note": "",
              "quantity": 1,
              "sku": "D251C7EDF5A7C49B",
              "taxable": true,
              "title": "Brerewood Power Remote Kit"
            }
          ],
          "payment": {
            "cash": 0,
            "check": 4544,
            "credit": 0,
            "gift_card": 0,
            "store_credit": 0
          }
        }
      }
      EOS
      def update
        respond_with Sale.find(params[:id]).update_attributes(params[:sale])
      end
      
      api :DELETE, "/sales/:id", "Destroy sale with given ID"
      param :id, String, :required => true
      error 404, "Not Found"
      example <<-EOS
        200 OK
      EOS
      def destroy
        respond_with Sale.destroy(params[:id])
      end
    end
  end
end