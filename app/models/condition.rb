class Condition
  include Mongoid::Document

  field :adjustment, :type => Float,    :default => 0
  field :adjustment_percentage, :type => Boolean,  :default => false
  field :adjustment_cash, :type => Float,    :default => 0
  field :adjustment_cash_percentage, :type => Boolean,  :default => false
  field :adjustment_credit, :type => Float,    :default => 0
  field :adjustment_credit_percentage, :type => Boolean,  :default => false
  field :description, :type => String
  field :name, :type => String
  
  index({ :account_id => 1, :name => 1, :identifier => 1 })
  
  validates_presence_of     :name, :adjustment, :adjustment_cash, :adjustment_credit, :item
  validates_inclusion_of    :adjustment_percentage, :in => [true, false]
  validates_inclusion_of    :adjustment_cash_percentage, :in => [true, false]
  validates_inclusion_of    :adjustment_credit_percentage, :in => [true, false]
  
  default_scope ->{ where(:account_id => Account.current_id) }
  
  belongs_to                :account
  belongs_to                :item
  has_and_belongs_to_many   :units
  
  liquid_methods :adjustment, :adjustment_percentage, :adjustment_cash, :adjustment_cash_percentage, :adjustment_credit, :adjustment_credit_percentage, :description, :name
  
  def adjuster(price)
    if adjustment_percentage
      (price * adjustment * 0.01).round.to_i
    else
      (adjustment * 100).to_i
    end
  end
end