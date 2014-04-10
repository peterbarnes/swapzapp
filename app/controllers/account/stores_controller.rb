class Account::StoresController < AdminController
  respond_to :html
  
  def index
    @stores = Store.search(params[:search]).sorted(params[:sort], params[:order])
    @stores = @stores.paginate(:page => params[:page], :per_page => params[:per_page])
    
    respond_with @stores
  end
  
  def show
    @store = Store.find_by(:id => params[:id])
    respond_with @store
  end
  
  def new
    @store = Store.new(:account => current_account)
    @store.phones.build
    @store.address = Address.new
    
    respond_with @store
  end
  
  def create
    @store = Store.new(params[:store])
    
    if @store.save
      track_activity @store
      flash[:notice] = 'Store created successfully!'
    end
    respond_with @store, :location => stores_path
  end

  def edit
    @store = Store.find_by(:id => params[:id])
    
    respond_with @store
  end
  
  def update
    @store = Store.find_by(:id => params[:id])
    
    if @store.update_attributes(params[:store])
      track_activity @store
      flash[:notice] = 'Store updated successfully!'
    end
    respond_with @store, :location => stores_path
  end
  
  def state
    render :partial => 'state', :locals => {:country => params[:country], :index => params[:index], :selected => params[:selected]}
  end
  
  def destroy
    @store = Store.find_by(:id => params[:id])
    @store.destroy
    
    track_activity @store
    flash[:notice] = 'Store deleted successfully!'
    
    respond_with @store
  end
end