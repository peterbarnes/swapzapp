class Inventory::InventoriesController < AdminController
  respond_to :html
  
  def index
    @inventories = Inventory.search(params[:search]).sorted(params[:sort], params[:order])
    @inventories = @inventories.paginate(:page => params[:page], :per_page => params[:per_page])
    
    respond_with @inventories
  end
  
  def new
    @inventory = Inventory.new(:account => current_account)
    
    respond_with @inventory
  end
  
  def create
    @inventory = Inventory.new(params[:inventory])
    
    if @inventory.save
      track_activity @inventory
      flash[:notice] = 'Inventory created successfully!'
    end
    respond_with @inventory, :location => inventories_path
  end
  
  def edit
    @inventory = Inventory.find_by(:id => params[:id])
    respond_with @inventory
  end
  
  def update
    @inventory = Inventory.find_by(:id => params[:id])
    
    if @inventory.update_attributes(params[:inventory])
      track_activity @inventory
      flash[:notice] = 'Inventory updated successfully!'
    end
    respond_with @inventory, :location => inventories_path
  end
  
  def destroy
    @inventory = Inventory.find_by(:id => params[:id])
    @inventory.destroy
    
    track_activity @inventory
    flash[:notice] = 'Inventory deleted successfully!'
    
    respond_with @inventory
  end
end