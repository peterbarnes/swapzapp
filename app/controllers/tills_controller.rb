class TillsController < AdminController
  respond_to :html
  
  def index
    @tills = Till.search(params[:search]).user_id(params[:user_id]).store_id(params[:store_id]).sorted(params[:sort])
    @tills = @tills.paginate(:page => params[:page], :per_page => params[:per_page])
    
    respond_with @tills
  end
  
  def show
    @till = Till.find_by(:id => params[:id])
    @till_metadata = TillMetadataSerializer.new(@till, :root => 'till').to_json
    
    respond_with @till
  end
  
  def new
    @till = Till.new(:account => current_account)
    
    respond_with @till
  end
  
  def create
    @till = Till.new(params[:till])
    
    if @till.save
      track_activity @till
      flash[:notice] = 'Till created successfully!'
    end
    respond_with @till
  end

  def edit
    @till = Till.find_by(:id => params[:id])
    
    respond_with @till
  end
  
  def update
    @till = Till.find_by(:id => params[:id])
    
    if @till.update_attributes(params[:till])
      track_activity @till
      flash[:notice] = 'Till updated successfully!'
    end
    respond_with @till
  end
  
  def release
    @till = Till.find_by(:id => params[:id])
    @till.update_attribute(:user, nil)
    
    flash[:notice] = 'Till released successfully!'
    
    redirect_to tills_path
  end
  
  def destroy
    @till = Till.find_by(:id => params[:id])
    @till.destroy
    
    track_activity @till
    flash[:notice] = 'Till deleted successfully!'
    
    respond_with @till
  end
end