class Operation::PurchasesController < AdminController
  respond_to :html
  skip_filter :authenticate, :only => [:template]
  
  def index
    @purchases = Purchase.search(params[:search])
    @purchases = @purchases.customer_id(params[:customer_id]).user_id(params[:user_id]).till_id(params[:till_id]).store_id(params[:store_id])
    @purchases = @purchases.sorted(params[:sort])
    @purchases = @purchases.paginate(:page => params[:page], :per_page => params[:per_page])
    
    respond_with @purchases
  end
  
  def show
    @purchase = Purchase.find_by(:id => params[:id])
    
    respond_with @purchase
  end
  
  def print
    @purchase = Purchase.find_by(:id => params[:id])
    @templates = current_account.templates.where(:category => 'purchase')
    @primary_template = @templates.where(:primary => true).first
    
    render
  end
  
  def template
    @purchase = Purchase.find_by(:id => params[:id])
    
    if params[:template]
      @template = current_account.templates.find(params[:template])
      @liquid = Liquid::Template.parse(@template.body)
      render :text => @liquid.render('purchase' => @purchase), :content_type => :html
    else
      render :layout => false
    end
  end
  
  def trend
    params[:period] ||= 0
    
    render :json => Purchase.trend(Time.current, params[:period])
  end
  
  def flag
    @purchase = Purchase.find_by(:id => params[:id])
    @purchase.update_attribute(:flagged, !@purchase.flagged)
    
    flash[:notice] = 'Purchase flagged successfully!'
    
    redirect_to purchases_path
  end
  
  def destroy
    @purchase = Purchase.find_by(:id => params[:id])
    @purchase.destroy
    
    track_activity @purchase
    flash[:notice] = 'Purchase deleted successfully!'
    
    respond_with @purchase
  end
end