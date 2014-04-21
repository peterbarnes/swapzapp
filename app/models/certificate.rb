class Certificate
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Search
  
  field :active,           :type => Boolean,   :default => false
  field :amount,           :type => Integer,   :default => 0
  field :balance,          :type => Integer,   :default => 0
  field :sku,              :type => String,    :default => ->{ SecureRandom.hex(8).upcase }
  
  index({ :account_id => 1, :sku => 1 })

  validates_presence_of     :amount, :balance, :sku
  validates_uniqueness_of   :sku, :scope => :account_id
  validates_inclusion_of    :active, :in => [true, false]
  
  default_scope ->{ where(:account_id => Account.current_id) }
  
  scope :search, ->(query) { query ? full_text_search(query) : all }
  scope :sorted, ->(sort, order) {
    if sort
      order ||= 'ASC'
      order_by("#{sort} #{order}")
    else
      asc(:active).desc(:created_at)
    end
  }
  scope :activated, ->(activated) { where(:active => activated) if activated }
  scope :customer_id, ->(customer_id) { where(:customer_id => customer_id) if customer_id }

  belongs_to  :account
  belongs_to  :customer
  has_many    :sales
  has_many    :repairs
  
  search_in :sku, :customer => [:first_name, :last_name, :sku]
  
  liquid_methods :account, :active, :amount, :balance, :sku, :created_at, :updated_at, :customer, :sales, :repairs
  
  def name
    sku
  end
  
  def add_balance(amount)
    update_attribute(:balance, balance + amount) if amount.is_a?(Integer)
  end
  
  def subtract_balance(amount)
    update_attribute(:balance, balance - amount) if amount.is_a?(Integer)
  end
end