class Operation::CertificatesController < AdminController
  respond_to :html
  skip_filter :authenticate, :only => [:template]
  
  def index
    @certificates = Certificate.search(params[:search]).customer_id(params[:customer_id]).sorted(params[:sort])
    @certificates = @certificates.paginate(:page => params[:page], :per_page => params[:per_page])
    
    respond_with @certificates
  end
  
  def show
    @certificate = Certificate.find_by(:id => params[:id])
    
    respond_with @certificate
  end
  
  def print
    @certificate = Certificate.find_by(:id => params[:id])
    @templates = current_account.templates.where(:category => 'certificate')
    
    render
  end
  
  def template
    @certificate = Certificate.find_by(:id => params[:id])
    
    if params[:template]
      @template = current_account.templates.find(params[:template])
      @liquid = Liquid::Template.parse(@template.body)
      render :text => @liquid.render('certificate' => @certificate), :content_type => :html
    else
      render :layout => false
    end
  end
  
  def new
    @certificate = Certificate.new(:account => current_account)
    
    respond_with @certificate
  end
  
  def create
    @certificate = Certificate.new(params[:certificate])
    
    if @certificate.save
      track_activity @certificate
      flash[:notice] = 'Certificate created successfully!'
    end
    respond_with @certificate
  end
  
  def edit
    @certificate = Certificate.find_by(:id => params[:id])
    
    respond_with @certificate
  end
  
  def update
    @certificate = Certificate.find_by(:id => params[:id])
    
    if @certificate.update_attributes(params[:certificate])
      track_activity @certificate
      flash[:notice] = 'Certificate updated successfully!'
    end
    respond_with @certificate
  end
  
  def activate
    @certificate = Certificate.find_by(:id => params[:id])
    @certificate.update_attribute(:active, true)
    
    flash[:notice] = 'Certificate activated successfully!'
    
    redirect_to certificates_path
  end
  
  def destroy
    @certificate = Certificate.find_by(:id => params[:id])
    @certificate.destroy
    
    track_activity @certificate
    
    flash[:notice] = 'Certificate deleted successfully!'
    
    respond_with @certificate
  end
end