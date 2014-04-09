module Api
  module V1
    class UnitsController < ApiController
      resource_description do
        short 'Units are preconfigured representations of items for sale'
        formats ['JSON']
        api_base_url '/api/v1'
      end
      
      skip_filter :user_time_zone
      
      respond_to :json
      
      def index
        @units = Unit.search(params[:search]).location_id(params[:location_id]).item_id(params[:item_id]).variant_id(params[:variant_id]).sorted(params[:sort], params[:order])
        @units = @units.paginate(:page => params[:page], :per_page => params[:per_page] == '0' ? @units.count : params[:per_page])
        @meta = { :total => @units.total_entries, :per_page => @units.per_page, :page => @units.current_page }
        
        respond_with @units, :each_serializer => UnitIndexSerializer, :meta => @meta
      end
      
      def show
        respond_with Unit.find(params[:id])
      end
      
      def create
        respond_with current_account.units.create(params[:unit])
      end
      
      def update
        respond_with Unit.find(params[:id]).update_attributes(params[:unit])
      end
      
      def destroy
        respond_with Unit.destroy(params[:id])
      end
    end
  end
end