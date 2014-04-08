require 'csv'

class AdjustmentsController < AdminController
  respond_to :html
  
  def index
    @till = Till.find_by(:id => params[:till_id])
    @adjustments = @till.adjustments.search(params[:search]).sorted(params[:sort], params[:order])
    @adjustments = @adjustments.paginate(:page => params[:page], :per_page => params[:per_page])
    
    respond_with @adjustments
  end
  
  def new
    @till = Till.find_by(:id => params[:till_id])
    @adjustment = @till.adjustments.new(:user => current_user, :balance => @till.balance)
    
    respond_with @adjustment
  end
  
  def create
    @till = Till.find_by(:id => params[:till_id])
    @adjustment = @till.adjustments.new(params[:adjustment])
    
    if @adjustment.save
      flash[:notice] = 'Adjustment created successfully!'
    end
    
    respond_with @adjustment, :location => till_adjustments_path(@till)
  end
  
  def csv
    @till = Till.find_by(:id => params[:till_id])
    @adjustments = @till.adjustments
    csv_string = CSV.generate do |csv|
      csv << ["ID", "Created At", "Title", "Description", "Amount", "User ID", "User Name"]
      @adjustments.each do |adjustment|
        row = [adjustment.id, adjustment.created_at, adjustment.title, adjustment.description, adjustment.amount]
        if adjustment.user
          row << adjustment.user.id
          row << adjustment.user.fullname
        else
          row << ""
          row << ""
        end
        csv << row
      end
    end

    send_data csv_string, :type => 'text/csv; charset=iso-8859-1; header=present', :disposition => "attachment; filename=adjustments_till_#{@till.id}.csv"
  end
end