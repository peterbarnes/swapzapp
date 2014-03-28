class Transfer
  include ActiveAttr::Model
  
  attribute :user
  attribute :destination
  attribute :amount
  attribute :description
  
  validates_presence_of :user, :destination, :amount
  
  liquid_methods :user, :destination, :amount, :description
  
  def complete(till)
    @till = till
    
    if valid?
      @user = User.find_by(:id => self.user)
      @destination = Till.find_by(:id => self.destination)
      
      @adjustment = @till.adjustments.new
      @adjustment_destination = @destination.adjustments.new
      
      @adjustment.balance = @till.balance
      @adjustment.amount = self.amount.to_i * -1
      @adjustment.description = self.description
      @adjustment.title = "Transfer to #{@destination.name} #{Time.now.to_s} (#{@user.fullname})"
      @adjustment.user = @user
      
      @adjustment_destination.balance = @destination.balance
      @adjustment_destination.amount = self.amount.to_i
      @adjustment_destination.description = self.description
      @adjustment_destination.title = "Transfer from #{@till.name} #{Time.now.to_s} (#{@user.fullname})"
      @adjustment_destination.user = @user
      
      @adjustment.save && @adjustment_destination.save
    else
      false
    end
  end
end