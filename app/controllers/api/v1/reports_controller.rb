module Api
  module V1
    class ReportsController < ApiController
      resource_description do
        short 'Reports represent exported data generated by the software'
        formats ['JSON']
        api_base_url '/api/v1'
      end
      
      def_param_group :report do
        param :report, Hash, :required => true, :action_aware => true do
          param :from, Date
          param :name, String
          param :to, Date
          param :job, String
        end
      end
      
      skip_filter :user_time_zone
      
      respond_to :json
      
      api :GET, "/reports/", "Retrieve an array of reports based on given filter params"
      param :search, String, :desc => "Full text query string for searching results"
      param :sort, String, :desc => "Property with which to sort results"
      param :order, ['ASC', 'DESC'], :desc => "Order in which to sort results (Default: ASC)"
      param :page, Integer, :desc => "The page number to return (Default: 1)"
      param :per_page, Integer, :desc => "The quantity of results per page (Default: 10)"
      meta ['total', 'per_page', 'page']
      example <<-EOS
      {
        "reports": [
          {
            "id": "5346a692f6f4072216000002",
            "complete": false,
            "file_url": "http://www.example.com/path/to/report.csv",
            "from": "2014-04-10",
            "name": "Example",
            "to": "2014-04-10",
            "job": "sales_export_csv",
            "created_at": "2014-04-10T14:11:30Z",
            "updated_at": "2014-04-10T14:11:30Z"
          }
        ],
        "meta": {
          "total": 1,
          "per_page": 10,
          "page": 1
        }
      }
      EOS
      def index
        @reports = Report.search(params[:search]).sorted(params[:sort], params[:order])
        @reports = @reports.paginate(:page => params[:page], :per_page => params[:per_page] == '0' ? @reports.count : params[:per_page])
        @meta = { :total => @reports.total_entries, :per_page => @reports.per_page, :page => @reports.current_page }
        
        respond_with @reports, :each_serializer => ReportIndexSerializer, :meta => @meta
      end
      
      api :GET, "/reports/:id", "Show report with given ID"
      param :id, String, :required => true
      error 404, "Not Found"
      example <<-EOS
      {
        "report": {
          "id": "5346a692f6f4072216000002",
          "complete": false,
          "file_url": "\/files\/original\/missing.png",
          "from": "2014-04-10",
          "name": "Example",
          "to": "2014-04-10",
          "job": "sales_export_csv",
          "created_at": "2014-04-10T14:11:30Z",
          "updated_at": "2014-04-10T14:11:30Z"
        }
      }
      EOS
      def show
        respond_with Report.find(params[:id])
      end
      
      api :POST, "/reports", "Create a new report with given params"
      param_group :report
      error 422, "Unprocessable Entity"
      example <<-EOS
      {
        "report": {
          "from": "2014-04-10",
          "name": "Example",
          "to": "2014-04-10",
          "job": "sales_export_csv"
        }
      }
      EOS
      def create
        respond_with current_account.reports.create(params[:report])
      end
      
      api :PUT, "/reports/:id", "Update an report with given params"
      param :id, String, :required => true
      param_group :report
      error 404, "Not Found"
      error 422, "Unprocessable Entity"
      example <<-EOS
      {
        "report": {
          "from": "2014-04-10",
          "name": "Example",
          "to": "2014-04-10",
          "job": "sales_export_csv"
        }
      }
      EOS
      def update
        respond_with Report.find(params[:id]).update_attributes(params[:report])
      end
      
      api :DELETE, "/reports/:id", "Destroy report with given ID"
      param :id, String, :required => true
      error 404, "Not Found"
      example <<-EOS
        200 OK
      EOS
      def destroy
        respond_with Report.destroy(params[:id])
      end
    end
  end
end