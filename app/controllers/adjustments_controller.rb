class AdjustmentsController < AdminController
  respond_to :html
  
  def index
    @till = Till.find_by(:id => params[:till_id])
    @adjustments = @till.adjustments.search(params[:search]).sorted(params[:sort])
    @adjustments = @adjustments.paginate(:page => params[:page], :per_page => params[:per_page])
    
    respond_with @adjustments
  end
  
  def new
    @till = Till.find_by(:id => params[:till_id])
    @adjustment = @till.adjustments.new(:user => current_user, :balance => @till.balance)
    
    respond_with @adjustment
  end
  
  def create
    @till = Till.find_by(:id => params[:till_id])
    @adjustment = @till.adjustments.new(params[:adjustment])
    
    if @adjustment.save
      flash[:notice] = 'Adjustment created successfully!'
    end
    
    respond_with @adjustment, :location => till_adjustments_path(@till)
  end
end