class Till
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Search
  
  field :balance,           :type => Integer,   :default => 0
  field :minimum,           :type => Integer,   :default => 0
  field :name,              :type => String
  field :tax_rate,          :type => Float,    :default => 0
  
  index({ :account_id => 1, :name => 1 })

  validates_presence_of     :balance, :minimum, :name, :tax_rate, :store
  
  default_scope ->{ where(:account_id => Account.current_id) }
  
  scope :search, ->(query) { query ? full_text_search(query) : all }
  scope :sorted, ->(sort, order) {
    if sort
      order ||= 'ASC'
      order_by("#{sort} #{order}")
    else
      asc(:name)
    end
  }
  scope :user_id, ->(user_id) { where(:user_id => user_id) if user_id }
  scope :store_id, ->(store_id) { where(:store_id => store_id) if store_id }
  scope :unassigned, ->(unassigned) { where(:user_id => nil) if unassigned }
  
  belongs_to  :account
  embeds_many :adjustments, cascade_callbacks: true
  has_many    :purchases
  has_many    :repairs
  belongs_to  :store
  has_many    :sales
  belongs_to  :user
  
  accepts_nested_attributes_for :adjustments, :allow_destroy => true
  
  search_in :name, :store => [:name]
  
  liquid_methods :adjustments, :adjustment_balance, :balance, :created_at, :minimum, :name, :purchases, :repairs, :store, :sales, :tax_rate, :updated_at, :user
  
  def adjustment_balance
    adjustment_balance = 0
    adjustments.each do |adjustment|
      adjustment_balance += adjustment.amount
    end
    adjustment_balance
  end
  
  def purge_adjustments(user)
    balance = self.adjustment_balance
    self.adjustments.destroy_all
    self.adjustments << Adjustment.new({
      :amount => balance,
      :balance => balance, 
      :user => user, 
      :title => 'Purge', 
      :description => Time.now.utc.to_s
    })
    self.save
  end
end