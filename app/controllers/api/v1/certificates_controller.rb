module Api
  module V1
    class CertificatesController < ApiController
      resource_description do
        short 'Gift certificates are used in transactions by customers'
        formats ['JSON']
        api_base_url '/api/v1'
      end
      
      skip_filter :certificate_time_zone
      
      respond_to :json
      
      api :GET, "/certificates/", "Retrieve an array of gift certificates based on given filter params"
      param :search, String, :desc => "Full text query string for searching results"
      param :sort, String, :desc => "Property with which to sort results"
      param :order, ['ASC', 'DESC'], :desc => "Order in which to sort results (Default: ASC)"
      param :page, Integer, :desc => "The page number to return (Default: 1)"
      param :per_page, Integer, :desc => "The quantity of results per page (Default: 10)"
      param :active, Boolean, :desc => "Retrieve only active gift certificates"
      param :customer_id, String, :desc => "Filter gift certificates by customer ID"
      param :customer, Boolean, :desc => "Include customer in results"
      param :sales, Boolean, :desc => "Include sales in results"
      meta ['total', 'per_page', 'page']
      example <<-EOS
      {
        "certificates": [
          {
            "id": "533aa6c6f6f407fccf0002d0",
            "customer_id": null,
            "active": false,
            "amount": 4187,
            "balance": 1842,
            "sku": "B82EA3B98932F764",
            "created_at": "2014-04-01T11:45:10Z",
            "updated_at": "2014-04-01T11:45:10Z"
          },
          {
            "id": "533aa6c6f6f407fccf0002cf",
            "customer_id": "533aa674f6f407fccf000140",
            "active": false,
            "amount": 7614,
            "balance": 2817,
            "sku": "125354417FD05E18",
            "created_at": "2014-04-01T11:45:10Z",
            "updated_at": "2014-04-01T11:45:10Z"
          },
          ...
          {
            "id": "533aa6c6f6f407fccf0002b5",
            "customer_id": "533aa697f6f407fccf0001de",
            "active": false,
            "amount": 6173,
            "balance": 3580,
            "sku": "35D48720E1C37AD6",
            "created_at": "2014-04-01T11:45:10Z",
            "updated_at": "2014-04-01T11:45:10Z"
          }
        ],
        "meta": {
          "total": 38,
          "per_page": 10,
          "page": 1
        }
      }
      EOS
      def index
        @certificates = Certificate.search(params[:search]).sorted(params[:sort], params[:order]).customer_id(params[:customer_id]).activated(params[:active])
        @certificates = @certificates.paginate(:page => params[:page], :per_page => params[:per_page] == '0' ? @certificates.count : params[:per_page])
        @meta = { :total => @certificates.total_entries, :per_page => @certificates.per_page, :page => @certificates.current_page }
        
        respond_with @certificates, :each_serializer => CertificateIndexSerializer, :meta => @meta
      end
      
      api :GET, "/certificates/:id", "Show gift certificate with given ID"
      param :id, String, :required => true
      param :sales, Boolean, :desc => "Include sales in results"
      error 404, "Not Found"
      example <<-EOS
        {
          "certificate": {
            "id": "533aa6c6f6f407fccf0002cf",
            "customer_id": "533aa674f6f407fccf000140",
            "active": false,
            "amount": 7614,
            "balance": 2817,
            "sku": "125354417FD05E18",
            "created_at": "2014-04-01T11:45:10Z",
            "updated_at": "2014-04-01T11:45:10Z",
            "customer": {...}
        }
      EOS
      def show
        respond_with Certificate.find(params[:id])
      end
      
      api :POST, "/certificates", "Create new gift certificate with given params"
      param :certificate, Hash, :required => true do
        param :customer_id, String, "Customer ID that gift certificate belongs to"
        param :active, Boolean, "Whether or not user is active"
        param :amount, Integer, :required => true
        param :balance, Integer, :required => true
        param :sku, String
      end
      error 422, "Unprocessable Entity"
      example <<-EOS
        {
          "certificate": {
            "customer_id": "533aa674f6f407fccf000140",
            "active": false,
            "amount": 7614,
            "balance": 2817,
            "sku": "125354417FD05E18"
        }
      EOS
      def create
        respond_with current_account.certificates.create(params[:certificate])
      end
      
      api :PUT, "/certificates/:id", "Update gift certificate with given params"
      param :id, String, :required => true
      param :certificate, Hash, :required => true do
        param :customer_id, String, "Customer ID that gift certificate belongs to"
        param :active, Boolean, "Whether or not user is active"
        param :amount, Integer
        param :balance, Integer
        param :sku, String
      end
      error 404, "Not Found"
      error 422, "Unprocessable Entity"
      example <<-EOS
        {
          "certificate": {
            "customer_id": "533aa674f6f407fccf000140",
            "active": false,
            "amount": 7614,
            "balance": 2817,
            "sku": "125354417FD05E18"
        }
      EOS
      def update
        respond_with Certificate.find(params[:id]).update_attributes(params[:certificate])
      end
      
      api :DELETE, "/certificates/:id", "Destroy certificate with given ID"
      error 404, "Not Found"
      example <<-EOS
        200 OK
      EOS
      def destroy
        respond_with Certificate.destroy(params[:id])
      end
    end
  end
end