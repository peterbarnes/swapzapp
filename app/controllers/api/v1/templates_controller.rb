module Api
  module V1
    class TemplatesController < ApiController
      skip_filter :user_time_zone
      
      respond_to :json
      
      def index
        @templates = current_account.templates.search(params[:search]).categorized(params[:category]).sorted(params[:sort], params[:order])
        @templates = @templates.paginate(:page => params[:page], :per_page => params[:per_page] == '0' ? @templates.count : params[:per_page])
        @meta = { :total => @templates.total_entries, :per_page => @templates.per_page, :page => @templates.current_page }
        
        respond_with @templates, :each_serializer => TemplateIndexSerializer, :meta => @meta
      end
      
      def show
        respond_with current_account.templates.find(params[:id])
      end
      
      def create
        respond_with current_account.templates.create(params[:template])
      end
      
      def update
        respond_with current_account.templates.find(params[:id]).update_attributes(params[:template])
      end
      
      def destroy
        respond_with current_account.templates.destroy(params[:id])
      end
    end
  end
end