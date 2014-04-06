class Operation::RepairsController < AdminController
  respond_to :html
  skip_filter :authenticate, :only => [:template]
  
  def index
    @repairs = Repair.search(params[:search])
    @repairs = @repairs.user_id(params[:user_id]).customer_id(params[:customer_id]).location_id(params[:location_id]).store_id(params[:store_id])
    @repairs = @repairs.sorted(params[:sort])
    @repairs = @repairs.paginate(:page => params[:page], :per_page => params[:per_page])
    
    respond_with @repairs
  end
  
  def show
    @repair = Repair.find_by(:id => params[:id])
    
    respond_with @repair
  end
  
  def print
    @repair = Repair.find_by(:id => params[:id])
    @templates = current_account.templates.where(:category => 'repair')
    @primary_template = @templates.where(:primary => true).first
    
    render
  end
  
  def template
    @repair = Repair.find_by(:id => params[:id])
    
    if params[:template]
      @template = current_account.templates.find(params[:template])
      @liquid = Liquid::Template.parse(@template.body)
      render :text => @liquid.render('repair' => @repair), :content_type => :html
    else
      render :layout => false
    end
  end
  
  def flag
    @repair = Repair.find_by(:id => params[:id])
    @repair.update_attribute(:flagged, !@repair.flagged)
    
    flash[:notice] = 'Repair flagged successfully!'
    
    redirect_to repairs_path
  end
  
  def destroy
    @repair = Repair.find_by(:id => params[:id])
    @repair.destroy
    
    track_activity @repair
    flash[:notice] = 'Repair deleted successfully!'
    
    respond_with @repair
  end
end