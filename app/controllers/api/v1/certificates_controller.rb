module Api
  module V1
    class CertificatesController < ApiController
      skip_filter :user_time_zone
      
      respond_to :json
      
      def index
        @certificates = Certificate.search(params[:search]).customer_id(params[:customer_id]).sorted(params[:sort])
        @certificates = @certificates.paginate(:page => params[:page], :per_page => params[:per_page] == '0' ? @certificates.count : params[:per_page])
        @meta = { :total => @certificates.total_entries, :per_page => @certificates.per_page, :page => @certificates.current_page }
        
        respond_with @certificates, :each_serializer => CertificateIndexSerializer, :meta => @meta
      end
      
      def show
        respond_with Certificate.find(params[:id])
      end
      
      def create
        respond_with current_account.certificates.create(params[:certificate])
      end
      
      def update
        respond_with Certificate.find(params[:id]).update_attributes(params[:certificate])
      end
      
      def destroy
        respond_with Certificate.destroy(params[:id])
      end
    end
  end
end