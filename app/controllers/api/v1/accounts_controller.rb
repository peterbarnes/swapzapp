module Api
  module V1
    class AccountsController < ApiController
      resource_description do
        short 'Retrieve information about account'
        formats ['JSON']
        api_base_url '/api/v1'
      end
      
      skip_filter :user_time_zone
      
      respond_to :json
      
      api :GET, "/account", "Show account information"
      example <<-EOS
        {
          "account": {
            "id": "533aa62ff6f407fccf000001",
            "api_active": true,
            "api_secret": "a6f128a09bc00131a239109add6b8334",
            "namespace": "e432a553351714d4f36dad2fc58817b810368f57e3f59c4aafb569e8112621f7",
            "title": "Example",
            "token": "example",
            "created_at": "2014-04-01T11:42:39Z",
            "updated_at": "2014-04-01T11:42:39Z"
          }
        }
      EOS
      def show
        respond_with current_account
      end
      
      api :GET, "/account/metadata", "Show account metadata information"
      description "Information for connecting to account API and socket server"
      example <<-EOS
        {
          "account": {
            "api": {
              "url": "http:\/\/example.10.0.1.60.xip.io\/api",
              "key": "x",
              "secret": "a6f128a09bc00131a239109add6b8334",
              "active": true
            },
            "title": "Example",
            "token": "example"
          }
        }
      EOS
      def metadata
        respond_with AccountMetadataSerializer.new(current_account, :root => 'account')
      end
    end
  end
end