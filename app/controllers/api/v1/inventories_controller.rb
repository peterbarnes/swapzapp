module Api
  module V1
    class InventoriesController < ApiController
      skip_filter :user_time_zone
      
      respond_to :json
      
      def index
        @inventories = Inventory.search(params[:search]).sorted(params[:sort])
        @inventories = @inventories.paginate(:page => params[:page], :per_page => params[:per_page] == '0' ? @inventories.count : params[:per_page])
        @meta = { :total => @inventories.total_entries, :per_page => @inventories.per_page, :page => @inventories.current_page }
        
        respond_with @inventories, :each_serializer => InventoryIndexSerializer, :meta => @meta
      end
      
      def show
        respond_with Inventory.find(params[:id])
      end
      
      def create
        respond_with current_account.inventories.create(params[:inventory])
      end
      
      def update
        respond_with Inventory.find(params[:id]).update_attributes(params[:inventory])
      end
      
      def destroy
        respond_with Inventory.destroy(params[:id])
      end
    end
  end
end