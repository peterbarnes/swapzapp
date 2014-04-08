class ActivitiesController < AdminController
  respond_to :html
  
  def index
    @activities = Activity.search(params[:search]).user_id(params[:user_id]).sorted(params[:sort], params[:order])
    @activities = @activities.paginate(:page => params[:page], :per_page => params[:per_page])
    
    respond_with @activities
  end
end