class DashboardController < AdminController
  
  def index
    @sales_data = Sale.trend(Time.current, 7)
    @purchases_data = Purchase.trend(Time.current, 7)
    
    @sales_today = @sales_data.find{|s| s[:day] == 0 }
    @purchases_today = @purchases_data.find{|p| p[:day] == 0 }
    
    @activities = Activity.sorted(params[:sort]).limit(5)
    
    render
  end
end