module Api
  module V1
    class AccountsController < ApiController
      skip_filter :user_time_zone
      
      respond_to :json
      
      def show
        respond_with current_account
      end
      
      def metadata
        respond_with AccountMetadataSerializer.new(current_account, :root => 'account')
      end
    end
  end
end