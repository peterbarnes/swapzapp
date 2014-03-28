module Api
  module V1
    class TillsController < ApiController
      skip_filter :till_time_zone
      
      respond_to :json
      
      def index
        @tills = Till.search(params[:search]).user_id(params[:user_id]).store_id(params[:store_id]).unassigned(params[:unassigned]).sorted(params[:sort])
        @tills = @tills.paginate(:page => params[:page], :per_page => params[:per_page] == '0' ? @tills.count : params[:per_page])
        @meta = { :total => @tills.total_entries, :per_page => @tills.per_page, :page => @tills.current_page }
        
        respond_with @tills, :each_serializer => TillIndexSerializer, :meta => @meta
      end
      
      def show
        respond_with Till.find(params[:id])
      end
      
      def metadata
        respond_with TillMetadataSerializer.new(Till.find(params[:id]), :root => 'till')
      end
      
      def create
        respond_with current_account.tills.create(params[:till])
      end
      
      def update
        respond_with Till.find(params[:id]).update_attributes(params[:till])
      end
      
      def destroy
        respond_with Till.destroy(params[:id])
      end
    end
  end
end