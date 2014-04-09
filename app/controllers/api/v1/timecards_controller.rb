module Api
  module V1
    class TimecardsController < ApiController
      resource_description do
        short 'Timecards track users hours by clocking in and out'
        formats ['JSON']
        api_base_url '/api/v1'
      end
      
      def_param_group :timecard do
        param :timecard, Hash, :required => true, :action_aware => true do
          param :user_id, String, :required => true
          param :flagged, Boolean
          param :in, String, :desc => "Datetime in ISO 8601 format"
          param :note, String
          param :out, String, :desc => "Datetime in ISO 8601 format"
        end
      end
      
      skip_filter :user_time_zone
      
      respond_to :json
      
      api :GET, "/timecards/", "Retrieve an array of timecards based on given filter params"
      param :search, String, :desc => "Full text query string for searching results"
      param :sort, String, :desc => "Property with which to sort results"
      param :order, ['ASC', 'DESC'], :desc => "Order in which to sort results (Default: ASC)"
      param :page, Integer, :desc => "The page number to return (Default: 1)"
      param :per_page, Integer, :desc => "The quantity of results per page (Default: 10)"
      param :user, Boolean, :desc => "Include user in results"
      param :user_id, String, :desc => "Filter results by user ID"
      meta ['total', 'per_page', 'page']
      example <<-EOS
      {
        "timecards": [
          {
            "id": "5342b5c6f6f407c20100000e",
            "user_id": "533aa62ff6f407fccf000002",
            "flagged": false,
            "in": "2014-04-07T14:27:18Z",
            "note": "",
            "out": "2014-04-07T14:27:30Z",
            "hours": 0.0033424999978807,
            "created_at": "2014-04-07T14:27:18Z",
            "updated_at": "2014-04-07T14:27:30Z"
          },
          {
            "id": "5342b5c1f6f407c20100000d",
            "user_id": "533aa62ff6f407fccf000002",
            "flagged": false,
            "in": "2014-04-07T14:27:13Z",
            "note": "",
            "out": "2014-04-07T14:27:41Z",
            "hours": 0.0079258333312141,
            "created_at": "2014-04-07T14:27:13Z",
            "updated_at": "2014-04-07T14:27:41Z"
          },
          ...
          {
            "id": "533aa796f6f407fccf000a12",
            "user_id": "533aa62ff6f407fccf000003",
            "flagged": false,
            "in": "2014-03-12T08:48:38Z",
            "note": "Dolores consequatur et numquam magnam nostrum excepturi dignissimos officia.",
            "out": "2014-03-31T20:48:38Z",
            "hours": 468,
            "created_at": "2014-04-01T11:48:38Z",
            "updated_at": "2014-04-01T11:48:38Z"
          }
        ],
        "meta": {
          "total": 47,
          "per_page": 10,
          "page": 1
        }
      }
      EOS
      def index
        @timecards = Timecard.search(params[:search]).sorted(params[:sort], params[:order]).user_id(params[:user_id])
        @timecards = @timecards.paginate(:page => params[:page], :per_page => params[:per_page] == '0' ? @timecards.count : params[:per_page])
        @meta = { :total => @timecards.total_entries, :per_page => @timecards.per_page, :page => @timecards.current_page }
        
        respond_with @timecards, :each_serializer => TimecardIndexSerializer, :meta => @meta
      end
      
      api :GET, "/timecards/:id", "Show timecard with given ID"
      param :id, String, :required => true
      error 404, "Not Found"
      example <<-EOS
      {
        "timecard": {
          "id": "5342b5c6f6f407c20100000e",
          "user_id": "533aa62ff6f407fccf000002",
          "flagged": false,
          "in": "2014-04-07T14:27:18Z",
          "note": "",
          "out": "2014-04-07T14:27:30Z",
          "hours": 0.0033424999978807,
          "created_at": "2014-04-07T14:27:18Z",
          "updated_at": "2014-04-07T14:27:30Z",
          "user": {...}
        }
      }
      EOS
      def show
        respond_with Timecard.find(params[:id])
      end
      
      api :POST, "/timecards", "Create a new timecard with given params"
      param_group :timecard
      error 422, "Unprocessable Entity"
      example <<-EOS
      {
        "timecard": {
          "user_id": "533aa62ff6f407fccf000002",
          "flagged": false,
          "in": "2014-04-07T14:27:18Z",
          "note": "",
          "out": "2014-04-07T14:27:30Z"
        }
      }
      EOS
      def create
        respond_with current_account.timecards.create(params[:timecard])
      end
      
      api :PUT, "/timecards/:id", "Update a timecard with given params"
      param :id, String, :required => true
      param_group :timecard
      error 404, "Not Found"
      error 422, "Unprocessable Entity"
      example <<-EOS
      {
        "timecard": {
          "user_id": "533aa62ff6f407fccf000002",
          "flagged": false,
          "in": "2014-04-07T14:27:18Z",
          "note": "",
          "out": "2014-04-07T14:27:30Z"
        }
      }
      EOS
      def update
        @timecard = Timecard.find(params[:id])
        @timecard.update_attributes(params[:timecard])
        respond_with @timecard
      end
      
      api :DELETE, "/timecards/:id", "Destroy timecard with given ID"
      param :id, String, :required => true
      error 404, "Not Found"
      example <<-EOS
        200 OK
      EOS
      def destroy
        @timecard = Timecard.find(params[:id])
        @timecard.destroy
        respond_with @timecard
      end
    end
  end
end