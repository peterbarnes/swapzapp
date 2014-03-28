class TransfersController < AdminController
  
  def new
    @till = Till.find_by(:id => params[:till_id])
    @transfer = Transfer.new(:user => current_user.id.to_s, :till => @till)
    
    render
  end
  
  def create
    @till = Till.find_by(:id => params[:till_id])
    @transfer = Transfer.new(params[:transfer])
    
    if @transfer.complete(@till)
      redirect_to till_path(@till), :notice => "Transfer created successfully!"
    else
      render :new
    end
  end
end