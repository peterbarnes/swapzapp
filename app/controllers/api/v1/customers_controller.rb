module Api
  module V1
    class CustomersController < ApiController
      skip_filter :user_time_zone
      
      respond_to :json
      
      def index
        @customers = Customer.search(params[:search]).sorted(params[:sort])
        @customers = @customers.paginate(:page => params[:page], :per_page => params[:per_page] == '0' ? @customers.count : params[:per_page])
        @meta = { :total => @customers.total_entries, :per_page => @customers.per_page, :page => @customers.current_page }
        
        respond_with @customers, :each_serializer => CustomerIndexSerializer, :meta => @meta
      end
      
      def show
        respond_with Customer.find(params[:id])
      end
      
      def create
        respond_with current_account.customers.create(params[:customer])
      end
      
      def update
        respond_with Customer.find(params[:id]).update_attributes(params[:customer])
      end
      
      def destroy
        respond_with Customer.destroy(params[:id])
      end
    end
  end
end