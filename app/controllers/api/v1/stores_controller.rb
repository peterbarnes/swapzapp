module Api
  module V1
    class StoresController < ApiController
      skip_filter :user_time_zone
      
      respond_to :json
      
      def index
        @stores = Store.search(params[:search]).sorted(params[:sort], params[:order])
        @stores = @stores.paginate(:page => params[:page], :per_page => params[:per_page] == '0' ? @stores.count : params[:per_page])
        @meta = { :total => @stores.total_entries, :per_page => @stores.per_page, :page => @stores.current_page }
        
        respond_with @stores, :each_serializer => StoreIndexSerializer, :meta => @meta
      end
      
      def show
        respond_with Store.find(params[:id])
      end
      
      def create
        respond_with current_account.stores.create(params[:store])
      end
      
      def update
        respond_with Store.find(params[:id]).update_attributes(params[:store])
      end
      
      def destroy
        respond_with Store.destroy(params[:id])
      end
    end
  end
end