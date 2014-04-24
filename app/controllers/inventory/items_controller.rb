class Inventory::ItemsController < AdminController
  respond_to :html
  
  def index
    @items = Item.searched(params[:search]).inventory_id(params[:inventory_id]).sorted(params[:sort], params[:order])
    @items = @items.paginate(:page => params[:page], :per_page => params[:per_page])
    
    respond_with @items
  end
  
  def show
    @item = Item.find_by(:id => params[:id])
    
    respond_with @item
  end
  
  def new
    @item = Item.new(:account => current_account)
    
    respond_with @item
  end
  
  def create
    @item = Item.new(params[:item])
    
    if @item.save
      track_activity @item
      flash[:notice] = 'Item created successfully!'
    end
    respond_with @item
  end
  
  def edit
    @item = Item.find_by(:id => params[:id])

    respond_with @item
  end
  
  def update
    @item = Item.find_by(:id => params[:id])
    
    if @item.update_attributes(params[:item])
      track_activity @item
      flash[:notice] = 'Item updated successfully!'
    end
    respond_with @item
  end
  
  def destroy
    @item = Item.find_by(:id => params[:id])
    @item.destroy
    
    track_activity @item
    flash[:notice] = 'Item deleted successfully!'
    
    respond_with @item
  end
end