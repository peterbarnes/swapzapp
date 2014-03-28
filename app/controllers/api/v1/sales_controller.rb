module Api
  module V1
    class SalesController < ApiController
      skip_filter :user_time_zone
      
      respond_to :json
      
      def index
        @sales = Sale.search(params[:search])
        @sales = @sales.customer_id(params[:customer_id]).user_id(params[:user_id]).till_id(params[:till_id]).store_id(params[:store_id])
        @sales = @sales.sorted(params[:sort])
        @sales = @sales.paginate(:page => params[:page], :per_page => params[:per_page] == '0' ? @sales.count : params[:per_page])
        @meta = { :total => @sales.total_entries, :per_page => @sales.per_page, :page => @sales.current_page }
        
        respond_with @sales, :each_serializer => SaleIndexSerializer, :meta => @meta
      end
      
      def show
        respond_with Sale.find(params[:id])
      end
      
      def create
        respond_with current_account.sales.create(params[:sale])
      end
      
      def update
        respond_with Sale.find(params[:id]).update_attributes(params[:sale])
      end
      
      def destroy
        respond_with Sale.destroy(params[:id])
      end
    end
  end
end