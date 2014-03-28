class ReportsController < AdminController
  respond_to :html
  
  def index
    @reports = Report.search(params[:search]).sorted(params[:sort])
    @reports = @reports.paginate(:page => params[:page], :per_page => params[:per_page])
    
    respond_with @reports
  end
  
  def new
    @report = Report.new(:account => current_account)
    
    respond_with @report
  end
  
  def create
    @report = Report.new(params[:report])
    
    if @report.save
      track_activity @report
      Delayed::Job.enqueue Job.find(@report.job).handler.constantize.new(current_account.id, current_user.id, @report.id)
      flash[:notice] = "Report is queued up and being generated..."
    end
    respond_with @report, :location => reports_path
  end
  
  def regenerate
    @report = Report.find_by(:id => params[:id])
    @report.update_attribute(:complete, false)
    Delayed::Job.enqueue @report.type.constantize.new(current_account.id, current_user.id, @report.id)
    flash[:notice] = "Report is queued up and being regenerated..."
    respond_with @report
  end
  
  def download
    @report = Report.find_by(:id => params[:id])
    if Rails.env.production?
      @data = open(@report.file.url)
      send_data @data.read, :type => @report.file_content_type, :x_sendfile => true
    else
      send_file @report.file.path, :type => @report.file_content_type
    end
  end
  
  def destroy
    @report = Report.find_by(:id => params[:id])
    @report.destroy
    
    track_activity @report
    flash[:notice] = 'Report deleted successfully!'
    
    respond_with @report
  end
end