class TimecardsController < AdminController
  
  def index
    @timecards = Timecard.searched(params[:search]).user_id(params[:user_id]).sorted(params[:sort], params[:order])
    @timecards = @timecards.paginate(:page => params[:page], :per_page => params[:per_page])
    
    render
  end
  
  def new
    @timecard = Timecard.new(:account => current_account)
    
    render
  end
  
  def create
    @timecard = Timecard.new(params[:timecard])
    
    if @timecard.save
      track_activity @timecard
      redirect_to timecards_path, :notice => 'Timecard created successfully!'
    else
      render :new
    end
  end

  def edit
    @timecard = Timecard.find_by(:id => params[:id])
    
    if @timecard
      render :edit
    else
      redirect_to timecards_path
    end
  end
  
  def update
    @timecard = Timecard.find_by(:id => params[:id])
    
    if @timecard.update_attributes(params[:timecard])
      track_activity @timecard
      redirect_to edit_timecard_path(@timecard), :notice => 'Timecard updated successfully!'
    else
      render :edit
    end
  end
  
  def flag
    @timecard = Timecard.find_by(:id => params[:id])
    @timecard.update_attribute(:flagged, !@timecard.flagged)
    
    redirect_to timecards_path
  end
  
  def clockout
    @timecard = Timecard.find_by(:id => params[:id])
    @timecard.update_attribute(:out, Time.now.utc) if @timecard
    
    redirect_to timecards_path
  end
  
  def destroy
    @timecard = Timecard.find_by(:id => params[:id])
    @timecard.destroy
    
    track_activity @timecard
    
    redirect_to timecards_path, :notice => 'Timecard deleted successfully!'
  end
end