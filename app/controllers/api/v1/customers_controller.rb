module Api
  module V1
    class CustomersController < ApiController
      resource_description do
        short 'Customers are the heart of transactions and can buy, sell or trade items or units'
        formats ['JSON']
        api_base_url '/api'
      end
      
      skip_filter :user_time_zone
      
      respond_to :json
      
      api :GET, "/customers/", "Retrieve an array of customers based on given filter params"
      param :search, String, :desc => "Full text query string for searching results"
      param :sort, String, :desc => "Property with which to sort results"
      param :order, ['ASC', 'DESC'], :desc => "Order in which to sort results (Default: ASC)"
      param :page, Integer, :desc => "The page number to return (Default: 1)"
      param :per_page, Integer, :desc => "The quantity of results per page (Default: 10)"
      param :addresses, Boolean, :desc => "Include addresses in results"
      param :certificates, Boolean, :desc => "Include certificates in results"
      param :phones, Boolean, :desc => "Include phones in results"
      param :purchases, Boolean, :desc => "Include purchases in results"
      param :repairs, Boolean, :desc => "Include repairs in results"
      param :sales, Boolean, :desc => "Include sales in results"
      meta ['total', 'per_page', 'page']
      example <<-EOS
      {
        "customers": [
          {
            "id": "533aa6aff6f407fccf00023f",
            "credit": 2662,
            "date_of_birth": "1995-11-15",
            "email": "leola@bahringer.co.uk",
            "first_name": "Megane",
            "identifier": "L738-342-67-321-4",
            "identifier_type": "NE",
            "last_name": "Abernathy",
            "notes": "Ratione assumenda reprehenderit aliquid neque nulla qui.",
            "organization": "Green-Kuphal",
            "sku": "A38F26C23B3D9343",
            "created_at": "2014-04-01T11:44:47Z",
            "updated_at": "2014-04-01T11:44:47Z",
            "images": [
              {
                "id": "533aa6aff6f407fccf000245",
                "name": "Trintforge",
                "index": 0,
                "description": "Quae consequatur aspernatur et sed molestias omnis.",
                "image_url": "\/system\/images\/images\/533a\/a6af\/f6f4\/07fc\/cf00\/0245\/original\/200?1396352684"
              }
            ]
          },
          {
            "id": "533aa6c3f6f407fccf000299",
            "credit": 7779,
            "date_of_birth": "2008-09-19",
            "email": "elisabeth_bosco@gleichner.biz",
            "first_name": "Sarina",
            "identifier": "Q096-841-51-063-4",
            "identifier_type": "MN",
            "last_name": "Altenwerth",
            "notes": "Quia illum sapiente repudiandae minus aliquam.",
            "organization": "Wunsch-Conn",
            "sku": "1378E9A317F07538",
            "created_at": "2014-04-01T11:45:08Z",
            "updated_at": "2014-04-01T11:45:08Z",
            "images": [...]
          },
          ...
          {
            "id": "533aa68cf6f407fccf0001a2",
            "credit": 3091,
            "date_of_birth": "2010-09-16",
            "email": "aidan.ledner@kutch.ca",
            "first_name": "Valentin",
            "identifier": "Y717-271-54-863-8",
            "identifier_type": "VT",
            "last_name": "Cole",
            "notes": "Minima qui autem facere.",
            "organization": "Batz, Goyette and Mohr",
            "sku": "9960E1585EE41CE9",
            "created_at": "2014-04-01T11:44:12Z",
            "updated_at": "2014-04-01T11:44:12Z",
            "images": [...]
          }
        ],
        "meta": {
          "total": 62,
          "per_page": 10,
          "page": 1
        }
      }
      EOS
      def index
        @customers = Customer.searched(params[:search]).sorted(params[:sort], params[:order])
        @customers = @customers.paginate(:page => params[:page], :per_page => params[:per_page] == '0' ? @customers.count : params[:per_page])
        @meta = { :total => @customers.total_entries, :per_page => @customers.per_page, :page => @customers.current_page }
        
        respond_with @customers, :each_serializer => CustomerIndexSerializer, :meta => @meta
      end
      
      api :GET, "/customers/:id", "Show customer with given ID"
      param :id, String, :required => true
      param :certificates, Boolean, :desc => "Include certificates in results"
      param :purchases, Boolean, :desc => "Include purchases in results"
      param :repairs, Boolean, :desc => "Include repairs in results"
      param :sales, Boolean, :desc => "Include sales in results"
      error 404, "Not Found"
      example <<-EOS
      {
        "customer": {
          "id": "533aa6aff6f407fccf00023f",
          "credit": 2662,
          "date_of_birth": "1995-11-15",
          "email": "leola@bahringer.co.uk",
          "first_name": "Megane",
          "identifier": "L738-342-67-321-4",
          "identifier_type": "NE",
          "last_name": "Abernathy",
          "notes": "Ratione assumenda reprehenderit aliquid neque nulla qui.",
          "organization": "Green-Kuphal",
          "sku": "A38F26C23B3D9343",
          "created_at": "2014-04-01T11:44:47Z",
          "updated_at": "2014-04-01T11:44:47Z",
          "addresses": [
            {
              "id": "533aa6aff6f407fccf000240",
              "name": "Home",
              "city": "Leuschkeshire",
              "country": "US",
              "first_line": "72028 Conn Mountains",
              "second_line": "Suite 131",
              "state": "HI",
              "zip": "55394"
            }
          ],
          "images": [
            {
              "id": "533aa6aff6f407fccf000245",
              "name": "Trintforge",
              "index": 0,
              "description": "Quae consequatur aspernatur et sed molestias omnis.",
              "image_url": "\/system\/images\/images\/533a\/a6af\/f6f4\/07fc\/cf00\/0245\/original\/200?1396352684"
            }
          ],
          "phones": [
            {
              "id": "533aa6aff6f407fccf00024a",
              "name": "Home",
              "number": "4446101498"
            }
          ]
        }
      }
      EOS
      def show
        respond_with Customer.find(params[:id])
      end
      
      api :POST, "/customers", "Create new customer with given params"
      param :certificate, Hash, :required => true do
        param :credit, Integer
        param :date_of_birth, String
        param :email, String
        param :first_name, String, :required => true
        param :identifier, String
        param :identifier_type, String
        param :last_name, String, :required => true
        param :notes, String
        param :organization, String
        param :sku, String
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
      error 422, "Unprocessable Entity"
      example <<-EOS
      {
        "customer": {
          "credit": 2662,
          "date_of_birth": "1995-11-15",
          "email": "leola@bahringer.co.uk",
          "first_name": "Megane",
          "identifier": "L738-342-67-321-4",
          "identifier_type": "NE",
          "last_name": "Abernathy",
          "notes": "Ratione assumenda reprehenderit aliquid neque nulla qui.",
          "organization": "Green-Kuphal",
          "sku": "A38F26C23B3D9343",
          "address_attributes": [
            {
              "name": "Home",
              "city": "Leuschkeshire",
              "country": "US",
              "first_line": "72028 Conn Mountains",
              "second_line": "Suite 131",
              "state": "HI",
              "zip": "55394"
            }
          ],
          "image_attributes": [
            {
              "name": "Trintforge",
              "index": 0,
              "description": "Quae consequatur aspernatur et sed molestias omnis.",
              "image_url": "\/system\/images\/images\/533a\/a6af\/f6f4\/07fc\/cf00\/0245\/original\/200?1396352684"
            }
          ],
          "phone_attributes": [
            {
              "name": "Home",
              "number": "4446101498"
            }
          ]
        }
      }
      EOS
      def create
        respond_with current_account.customers.create(params[:customer])
      end
      
      api :PUT, "/customers/:id", "Update customer with given params"
      param :id, String, :required => true
      param :certificate, Hash, :required => true do
        param :credit, Integer
        param :date_of_birth, String
        param :email, String
        param :first_name, String
        param :identifier, String
        param :identifier_type, String
        param :last_name, String
        param :notes, String
        param :organization, String
        param :sku, String
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
      error 404, "Not Found"
      error 422, "Unprocessable Entity"
      example <<-EOS
      {
        "customer": {
          "credit": 2662,
          "date_of_birth": "1995-11-15",
          "email": "leola@bahringer.co.uk",
          "first_name": "Megane",
          "identifier": "L738-342-67-321-4",
          "identifier_type": "NE",
          "last_name": "Abernathy",
          "notes": "Ratione assumenda reprehenderit aliquid neque nulla qui.",
          "organization": "Green-Kuphal",
          "sku": "A38F26C23B3D9343",
          "address_attributes": [
            {
              "name": "Home",
              "city": "Leuschkeshire",
              "country": "US",
              "first_line": "72028 Conn Mountains",
              "second_line": "Suite 131",
              "state": "HI",
              "zip": "55394"
            }
          ],
          "image_attributes": [
            {
              "name": "Trintforge",
              "index": 0,
              "description": "Quae consequatur aspernatur et sed molestias omnis.",
              "image_url": "\/system\/images\/images\/533a\/a6af\/f6f4\/07fc\/cf00\/0245\/original\/200?1396352684"
            }
          ],
          "phone_attributes": [
            {
              "name": "Home",
              "number": "4446101498"
            }
          ]
        }
      }
      EOS
      def update
        respond_with Customer.find(params[:id]).update_attributes(params[:customer])
      end
      
      api :DELETE, "/customers/:id", "Destroy customer with given ID"
      param :id, String, :required => true
      error 404, "Not Found"
      example <<-EOS
        200 OK
      EOS
      def destroy
        respond_with Customer.destroy(params[:id])
      end
    end
  end
end