class Account::TemplatesController < AdminController
  respond_to :html
  
  def index
    @templates = current_account.templates.search(params[:search]).sorted(params[:sort], params[:order])
    @templates = @templates.paginate(:page => params[:page], :per_page => params[:per_page])
    
    respond_with @templates
  end
  
  def show
    @template = current_account.templates.find_by(:id => params[:id])
    respond_with @template
  end
  
  def new
    @template = current_account.templates.new(:account => current_account)
    respond_with @template
  end
  
  def create
    @template = current_account.templates.new(params[:template])
    
    if @template.save
      flash[:notice] = 'Template created successfully!'
    end
    respond_with @template
  end

  def edit
    @template = current_account.templates.find_by(:id => params[:id])
    respond_with @template
  end
  
  def update
    @template = current_account.templates.find_by(:id => params[:id])
    
    if @template.update_attributes(params[:template])
      flash[:notice] = 'Template updated successfully!'
    end
    respond_with @template
  end
  
  def destroy
    @template = current_account.templates.find_by(:id => params[:id])
    @template.destroy

    flash[:notice] = 'Template deleted successfully!'
    
    respond_with @template
  end
  
  def primary
    @template = current_account.templates.find_by(:id => params[:id])
    @template.set_primary
    flash[:notice] = 'Template set as primary!'
    redirect_to templates_path
  end
end