module Api
  module V1
    class TimecardsController < ApiController
      skip_filter :user_time_zone
      
      respond_to :json
      
      def index
        @timecards = Timecard.search(params[:search]).user_id(params[:user_id]).sorted(params[:sort], params[:order])
        @timecards = @timecards.paginate(:page => params[:page], :per_page => params[:per_page] == '0' ? @timecards.count : params[:per_page])
        @meta = { :total => @timecards.total_entries, :per_page => @timecards.per_page, :page => @timecards.current_page }
        
        respond_with @timecards, :each_serializer => TimecardIndexSerializer, :meta => @meta
      end
      
      def show
        respond_with Timecard.find(params[:id])
      end
      
      def create
        respond_with current_account.timecards.create(params[:timecard])
      end
      
      def update
        @timecard = Timecard.find(params[:id])
        @timecard.update_attributes(params[:timecard])
        respond_with @timecard
      end
      
      def destroy
        @timecard = Timecard.find(params[:id])
        @timecard.destroy
        respond_with @timecard
      end
    end
  end
end