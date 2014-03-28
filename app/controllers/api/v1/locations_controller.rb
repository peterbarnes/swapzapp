module Api
  module V1
    class LocationsController < ApiController
      skip_filter :user_time_zone
      
      respond_to :json
      
      def index
        @locations = Location.search(params[:search]).store_id(params[:store_id]).sorted(params[:sort])
        @locations = @locations.paginate(:page => params[:page], :per_page => params[:per_page] == '0' ? @locations.count : params[:per_page])
        @meta = { :total => @locations.total_entries, :per_page => @locations.per_page, :page => @locations.current_page }
        
        respond_with @locations, :each_serializer => LocationIndexSerializer, :meta => @meta
      end
      
      def show
        respond_with Location.find(params[:id])
      end
      
      def create
        respond_with current_account.locations.create(params[:location])
      end
      
      def update
        respond_with Location.find(params[:id]).update_attributes(params[:location])
      end
      
      def destroy
        respond_with Location.destroy(params[:id])
      end
    end
  end
end