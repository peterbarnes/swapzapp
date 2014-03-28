class Inventory::LocationsController < AdminController
  respond_to :html
  
  def index
    if params[:parent_id]
      @locations = Location.find(params[:parent_id]).children.sorted(params[:sort])
    else
      @locations = Location.roots.search(params[:search]).store_id(params[:store_id]).sorted(params[:sort])
    end
    
    respond_with @locations
  end
  
  def show
    @location = Location.find(params[:id])
    
    respond_with @location
  end
  
  def new
    @location = Location.new(:account => current_account, :parent_id => params[:parent_id], :store_id => params[:store_id])
    
    respond_with @location
  end
  
  def create
    @location = Location.new(params[:location])
    
    if @location.save
      track_activity @location
      flash[:notice] = 'Location created successfully!'
    end
    respond_with @location
  end

  def edit
    @location = Location.find_by(:id => params[:id])
    
    respond_with @location
  end
  
  def update
    @location = Location.find_by(:id => params[:id])
    
    if @location.update_attributes(params[:location])
      track_activity @location
      flash[:notice] = 'Location updated successfully!'
    end
    respond_with @location
  end
  
  def destroy
    @location = Location.find_by(:id => params[:id])
    @location.destroy
    
    track_activity @location
    flash[:notice] = 'Location deleted successfully!'
    
    respond_with @location
  end
end