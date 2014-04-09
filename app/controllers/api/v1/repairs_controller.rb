module Api
  module V1
    class RepairsController < ApiController
      resource_description do
        short 'Repairs represent transactions where customers have things repaired'
        formats ['JSON']
        api_base_url '/api/v1'
      end
      
      skip_filter :user_time_zone
      
      respond_to :json
      
      def index
        @repairs = Repair.search(params[:search])
        @repairs = @repairs.user_id(params[:user_id]).customer_id(params[:customer_id]).location_id(params[:location_id]).store_id(params[:store_id])
        @repairs = @repairs.sorted(params[:sort], params[:order])
        @repairs = @repairs.paginate(:page => params[:page], :per_page => params[:per_page] == '0' ? @repairs.count : params[:per_page] ||= 10)
        @meta = { :total => @repairs.total_entries, :per_page => @repairs.per_page, :page => @repairs.current_page }
        
        respond_with @repairs, :each_serializer => RepairIndexSerializer, :meta => @meta
      end
      
      def show
        respond_with Repair.find(params[:id])
      end
      
      def create
        respond_with current_account.repairs.create(params[:repair])
      end
      
      def update
        respond_with Repair.find(params[:id]).update_attributes(params[:repair])
      end
      
      def destroy
        respond_with Repair.destroy(params[:id])
      end
    end
  end
end