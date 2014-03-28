module Api
  module V1
    class PurchasesController < ApiController
      skip_filter :user_time_zone
      
      respond_to :json
      
      def index
        @purchases = Purchase.search(params[:search])
        @purchases = @purchases.customer_id(params[:customer_id]).user_id(params[:user_id]).till_id(params[:till_id]).store_id(params[:store_id])
        @purchases = @purchases.sorted(params[:sort])
        @purchases = @purchases.paginate(:page => params[:page], :per_page => params[:per_page] == '0' ? @purchases.count : params[:per_page])
        @meta = { :total => @purchases.total_entries, :per_page => @purchases.per_page, :page => @purchases.current_page }
        
        respond_with @purchases, :each_serializer => PurchaseIndexSerializer, :meta => @meta
      end
      
      def show
        respond_with Purchase.find(params[:id])
      end
      
      def create
        respond_with current_account.purchases.create(params[:purchase])
      end
      
      def update
        respond_with Purchase.find(params[:id]).update_attributes(params[:purchase])
      end
      
      def destroy
        respond_with Purchase.destroy(params[:id])
      end
    end
  end
end