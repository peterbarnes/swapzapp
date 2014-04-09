module Api
  module V1
    class UnitsController < ApiController
      resource_description do
        short 'Units are preconfigured representations of items for sale'
        formats ['JSON']
        api_base_url '/api/v1'
      end
      
      def_param_group :unit do
        param :unit, Hash, :required => true, :action_aware => true do
          param :item_id, String, :required => true
          param :variant_id, String, :required => true
          param :filing, Integer
          param :price, Integer
          param :quantity, Integer
          param :sku, String
          param :taxable, Boolean
          param :calculated, Boolean, :desc => 'Whether to calculate price based on components, conditions, variant or use price'
          param :name, String
          param :component_ids, Array, :desc => 'An array of component IDs to associate with unit'
          param :condition_ids, Array, :desc => 'An array of condition IDs to associate with unit'
        end
      end
      
      skip_filter :user_time_zone
      
      respond_to :json
      
      api :GET, "/units/", "Retrieve an array of units based on given filter params"
      param :search, String, :desc => "Full text query string for searching results"
      param :sort, String, :desc => "Property with which to sort results"
      param :order, ['ASC', 'DESC'], :desc => "Order in which to sort results (Default: ASC)"
      param :page, Integer, :desc => "The page number to return (Default: 1)"
      param :per_page, Integer, :desc => "The quantity of results per page (Default: 10)"
      param :location_id, String, :desc => "Filter results by location ID"
      param :item_id, String, :desc => "Filter results by item ID"
      param :variant_id, String, :desc => "Filter results by variant ID"
      param :components, Boolean, :desc => "Include components in results"
      param :conditions, Boolean, :desc => "Include conditions in results"
      param :item, Boolean, :desc => "Include item in results"
      param :variant, Boolean, :desc => "Include variant in results"
      meta ['total', 'per_page', 'page']
      example <<-EOS
      {
        "units": [
          {
            "id": "533aa757f6f407fccf00074b",
            "item_id": "533aa71df6f407fccf00054c",
            "variant_id": "533aa721f6f407fccf000559",
            "filing_formatted": "000 0024",
            "price": 5721,
            "quantity": 2,
            "sku": "034EB3034A15",
            "taxable": false,
            "calculated": true,
            "name": "Reupod Portable Filter",
            "created_at": "2014-04-01T11:47:35Z",
            "updated_at": "2014-04-01T11:47:35Z"
          },
          {
            "id": "533aa756f6f407fccf00073c",
            "item_id": "533aa71af6f407fccf00052d",
            "variant_id": "533aa71df6f407fccf000537",
            "filing_formatted": "000 0009",
            "price": 5040,
            "quantity": 6,
            "sku": "056C59326FCD",
            "taxable": false,
            "calculated": false,
            "name": "Trinix Remote Tuner",
            "created_at": "2014-04-01T11:47:35Z",
            "updated_at": "2014-04-01T11:47:35Z"
          },
          ...
          {
            "id": "533aa758f6f407fccf000764",
            "item_id": "533aa709f6f407fccf0004a8",
            "variant_id": "533aa70ef6f407fccf0004b2",
            "filing_formatted": "000 0049",
            "price": 5767,
            "quantity": 36,
            "sku": "2A0886BA2E70",
            "taxable": true,
            "calculated": true,
            "name": "Phuffe Output Tuner",
            "created_at": "2014-04-01T11:47:36Z",
            "updated_at": "2014-04-01T11:47:36Z"
          }
        ],
        "meta": {
          "total": 61,
          "per_page": 10,
          "page": 1
        }
      }
      EOS
      def index
        @units = Unit.search(params[:search]).sorted(params[:sort], params[:order]).location_id(params[:location_id]).item_id(params[:item_id]).variant_id(params[:variant_id])
        @units = @units.paginate(:page => params[:page], :per_page => params[:per_page] == '0' ? @units.count : params[:per_page])
        @meta = { :total => @units.total_entries, :per_page => @units.per_page, :page => @units.current_page }
        
        respond_with @units, :each_serializer => UnitIndexSerializer, :meta => @meta
      end
      
      api :GET, "/units/:id", "Show unit with given ID"
      param :id, String, :required => true
      error 404, "Not Found"
      example <<-EOS
      {
        "unit": {
          "id": "533aa757f6f407fccf00074b",
          "item_id": "533aa71df6f407fccf00054c",
          "variant_id": "533aa721f6f407fccf000559",
          "filing_formatted": "000 0024",
          "price": 5721,
          "quantity": 2,
          "sku": "034EB3034A15",
          "taxable": false,
          "calculated": true,
          "name": "Reupod Portable Filter",
          "created_at": "2014-04-01T11:47:35Z",
          "updated_at": "2014-04-01T11:47:35Z",
          "components": [
            {
              "id": "533aa71df6f407fccf000550",
              "item_id": "533aa71df6f407fccf00054c",
              "adjustment": 0.71,
              "adjustment_percentage": true,
              "adjustment_cash": 1,
              "adjustment_cash_percentage": true,
              "adjustment_credit": 0.73,
              "adjustment_credit_percentage": true,
              "description": "Excepturi reiciendis magnam suscipit omnis et quisquam dolores.",
              "name": "Auto Portable Mount",
              "typical": false
            }
          ],
          "conditions": [
            {
              "id": "533aa71df6f407fccf000554",
              "item_id": "533aa71df6f407fccf00054c",
              "adjustment": -33.9636,
              "adjustment_percentage": false,
              "adjustment_cash": -35.0592,
              "adjustment_cash_percentage": false,
              "adjustment_credit": -40.5372,
              "adjustment_credit_percentage": false,
              "description": "Est est ad sit optio maiores dolores.",
              "name": "Acceptable"
            }
          ],
          "item": {...},
          "variant": {
            "id": "533aa721f6f407fccf000559",
            "item_id": "533aa71df6f407fccf00054c",
            "adjustment": 0.57,
            "adjustment_percentage": true,
            "adjustment_cash": 0.1,
            "adjustment_cash_percentage": true,
            "adjustment_credit": 0.95,
            "adjustment_credit_percentage": true,
            "description": "Odio sunt voluptates iure.",
            "name": "N31",
            "identifier": null,
            "identifier_type": "UPC"
          }
        }
      }
      EOS
      def show
        respond_with Unit.find(params[:id])
      end
      
      api :POST, "/units", "Create a new unit with given params"
      param_group :unit
      error 422, "Unprocessable Entity"
      example <<-EOS
      {
        "unit": {
          "item_id": "533aa71df6f407fccf00054c",
          "variant_id": "533aa721f6f407fccf000559",
          "filing": "000 0024",
          "price": 5721,
          "quantity": 2,
          "sku": "034EB3034A15",
          "taxable": false,
          "calculated": true,
          "name": "Reupod Portable Filter",
          "component_ids": ['533aa71df6f407fccf000550', ...],
          "condition_ids": ['533aa71df6f407fccf000554', ...]
        }
      }
      EOS
      def create
        respond_with current_account.units.create(params[:unit])
      end
      
      api :PUT, "/units/:id", "Update an unit with given params"
      param :id, String, :required => true
      param_group :unit
      error 404, "Not Found"
      error 422, "Unprocessable Entity"
      example <<-EOS
      {
        "unit": {
          "item_id": "533aa71df6f407fccf00054c",
          "variant_id": "533aa721f6f407fccf000559",
          "filing": "000 0024",
          "price": 5721,
          "quantity": 2,
          "sku": "034EB3034A15",
          "taxable": false,
          "calculated": true,
          "name": "Reupod Portable Filter",
          "component_ids": ['533aa71df6f407fccf000550', ...],
          "condition_ids": ['533aa71df6f407fccf000554', ...]
        }
      }
      EOS
      def update
        respond_with Unit.find(params[:id]).update_attributes(params[:unit])
      end
      
      api :DELETE, "/units/:id", "Destroy unit with given ID"
      param :id, String, :required => true
      error 404, "Not Found"
      example <<-EOS
        200 OK
      EOS
      def destroy
        respond_with Unit.destroy(params[:id])
      end
    end
  end
end