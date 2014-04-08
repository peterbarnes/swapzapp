class Operation::CustomersController < AdminController
  respond_to :html
  skip_filter :authenticate, :only => [:template]
  
  def index
    @customers = Customer.search(params[:search]).sorted(params[:sort], params[:order])
    @customers = @customers.paginate(:page => params[:page], :per_page => params[:per_page])
    
    respond_with @customers
  end
  
  def show
    @customer = Customer.find_by(:id => params[:id])
    
    respond_with @customer
  end
  
  def print
    @customer = Customer.find_by(:id => params[:id])
    @templates = current_account.templates.where(:category => 'customer')
    
    render
  end
  
  def template
    @customer = Customer.find_by(:id => params[:id])
    
    if params[:template]
      @template = current_account.templates.find(params[:template])
      @liquid = Liquid::Template.parse(@template.body)
      render :text => @liquid.render('customer' => @customer), :content_type => :html
    else
      render :layout => false
    end
  end
  
  def new
    @customer = Customer.new(:account => current_account)
    @customer.addresses.build
    @customer.phones.build
    
    respond_with @customer
  end
  
  def create
    @customer = Customer.new(params[:customer])
    
    if @customer.save
      track_activity @customer
      flash[:notice] = 'Customer created successfully!'
    end
    respond_with @customer
  end
  
  def edit
    @customer = Customer.find_by(:id => params[:id])
    
    respond_with @customer
  end
  
  def update
    @customer = Customer.find_by(:id => params[:id])
    
    if @customer.update_attributes(params[:customer])
      track_activity @customer
      flash[:notice] = 'Customer updated successfully!'
    end
    respond_with @customer
  end
  
  def state
    render :partial => 'state', :locals => {:country => params[:country], :index => params[:index], :selected => params[:selected]}
  end
  
  def destroy
    @customer = Customer.find_by(:id => params[:id])
    @customer.destroy
    
    track_activity @customer
    
    flash[:notice] = 'Customer deleted successfully!'
    
    respond_with @customer
  end
end