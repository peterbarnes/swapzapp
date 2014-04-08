class Inventory::UnitsController < AdminController
  respond_to :html
  
  def index
    @units = Unit.search(params[:search]).location_id(params[:location_id]).item_id(params[:item_id]).variant_id(params[:variant_id]).sorted(params[:sort], params[:order])
    @units = @units.paginate(:page => params[:page], :per_page => params[:per_page])
    
    respond_with @units
  end
  
  def show
    @unit = Unit.find_by(:id => params[:id])
    
    respond_with @unit
  end
  
  def new
    @unit = Unit.new(:account => current_account, :item_id => params[:item_id])
    
    respond_with @unit
  end
  
  def create
    @unit = Unit.new(params[:unit])
    
    if @unit.save
      flash[:notice] = 'Unit created successfully!'
    end
    respond_with @unit
  end
  
  def show
    @unit = Unit.find_by(:id => params[:id])
    
    respond_with @unit
  end
  
  def edit
    @unit = Unit.find_by(:id => params[:id])
    
    respond_with @unit
  end
  
  def update
    params[:unit][:component_ids] ||= []
    params[:unit][:condition_ids] ||= []
    
    @unit = Unit.find_by(:id => params[:id])
    
    if @unit.update_attributes(params[:unit])
      flash[:notice] = 'Unit updated successfully!'
    end
    respond_with @unit
  end
  
  def destroy
    @unit = Unit.find_by(:id => params[:id])
    @unit.destroy
    
    flash[:notice] = 'Unit deleted successfully!'
    
    respond_with @unit
  end
end