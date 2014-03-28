class Payment
  include Mongoid::Document

  field :cash,          :type => Integer,  :default => 0
  field :credit,        :type => Integer,  :default => 0
  field :check,         :type => Integer,  :default => 0
  field :gift_card,     :type => Integer,  :default => 0
  field :store_credit,  :type => Integer,  :default => 0
  
  attr_reader :total

  validates_presence_of   :cash, :credit, :check, :gift_card, :store_credit
  
  embedded_in     :repair
  embedded_in     :sale
  
  liquid_methods :cash, :credit, :check, :gift_card, :store_credit, :total
  
  def total
    cash + credit + check + gift_card
  end
end