module Api
  module V1
    class ReportsController < ApiController
      skip_filter :user_time_zone
      
      respond_to :json
      
      def index
        @reports = Report.search(params[:search]).sorted(params[:sort], params[:order])
        @reports = @reports.paginate(:page => params[:page], :per_page => params[:per_page] == '0' ? @reports.count : params[:per_page])
        @meta = { :total => @reports.total_entries, :per_page => @reports.per_page, :page => @reports.current_page }
        
        respond_with @reports, :each_serializer => ReportIndexSerializer, :meta => @meta
      end
      
      def show
        respond_with Report.find(params[:id])
      end
      
      def create
        respond_with current_account.reports.create(params[:report])
      end
      
      def update
        respond_with Report.find(params[:id]).update_attributes(params[:report])
      end
      
      def destroy
        respond_with Report.destroy(params[:id])
      end
    end
  end
end