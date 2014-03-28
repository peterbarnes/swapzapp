class Line
  include Mongoid::Document
  include Mongoid::Timestamps

  field :amount, :type => Integer,  :default => 0
  field :amount_cash, :type => Integer,  :default => 0
  field :amount_credit, :type => Integer,  :default => 0
  field :bullets, :type => Array, :default => []
  field :note, :type => String
  field :quantity, :type => Integer,  :default => 1
  field :sku, :type => String
  field :taxable, :type => Boolean,  :default => true
  field :title, :type => String
  
  attr_reader :subtotal, :subtotal_cash, :subtotal_credit
  
  validates_presence_of         :amount, :amount_cash, :amount_credit, :quantity, :title
  validates_inclusion_of        :taxable, :in => [true, false]
  
  belongs_to      :certificate
  belongs_to      :item
  embedded_in     :purchase
  embedded_in     :repair
  embedded_in     :sale
  belongs_to      :unit
  
  liquid_methods :amount, :amount_cash, :amount_credit, :bullets, :certificate, :created_at, :note, :quantity, :sku, :subtotal, :subtotal_cash, :subtotal_credit, :taxable, :title, :unit, :updated_at
  
  def subtotal
    quantity * amount
  end
  
  def subtotal_cash
    quantity * amount_cash
  end
  
  def subtotal_credit
    quantity * amount_credit
  end
end