class Operation::SalesController < AdminController
  respond_to :html
  skip_filter :authenticate, :only => [:template]
  
  def index
    @sales = Sale.search(params[:search])
    @sales = @sales.customer_id(params[:customer_id]).user_id(params[:user_id]).till_id(params[:till_id]).store_id(params[:store_id])
    @sales = @sales.sorted(params[:sort])
    @sales = @sales.paginate(:page => params[:page], :per_page => params[:per_page])
    
    respond_with @sales
  end
  
  def show
    @sale = Sale.find_by(:id => params[:id])
    
    respond_with @sale
  end
  
  def print
    @sale = Sale.find_by(:id => params[:id])
    @templates = current_account.templates.where(:category => 'sale')
    
    render
  end
  
  def template
    @sale = Sale.find_by(:id => params[:id])
    
    if params[:template]
      @template = current_account.templates.find(params[:template])
      @liquid = Liquid::Template.parse(@template.body)
      render :text => @liquid.render('sale' => @sale), :content_type => :html
    else
      render :layout => false
    end
  end
  
  def trend
    params[:period] ||= 0
    
    render :json => Sale.trend(Time.current, params[:period])
  end
  
  def flag
    @sale = Sale.find_by(:id => params[:id])
    @sale.update_attribute(:flagged, !@sale.flagged)
    
    flash[:notice] = 'Sale flagged successfully!'
    
    redirect_to sales_path
  end
  
  def destroy
    @sale = Sale.find_by(:id => params[:id])
    @sale.destroy
    
    track_activity @sale
    flash[:notice] = 'Sale deleted successfully!'
    
    respond_with @sale
  end
end