module Api
  module V1
    class ItemsController < ApiController
      skip_filter :user_time_zone
      
      respond_to :json
      
      def index
        @items = Item.search(params[:search]).inventory_id(params[:inventory_id]).sorted(params[:sort])
        @items = @items.paginate(:page => params[:page], :per_page => params[:per_page] == '0' ? @items.count : params[:per_page])
        @meta = { :total => @items.total_entries, :per_page => @items.per_page, :page => @items.current_page }
        
        respond_with @items, :each_serializer => ItemIndexSerializer, :meta => @meta
      end
      
      def show
        respond_with Item.find(params[:id])
      end
      
      def create
        respond_with current_account.items.create(params[:item])
      end
      
      def update
        respond_with Item.find(params[:id]).update_attributes(params[:item])
      end
      
      def destroy
        respond_with Item.destroy(params[:id])
      end
    end
  end
end