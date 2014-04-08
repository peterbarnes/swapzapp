class Repair
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::MultiParameterAttributes
  include Mongoid::Search
  
  field :complete,        :type => Boolean,  :default => false
  field :completed_at,    :type => Time
  field :flagged,         :type => Boolean,  :default => false
  field :identifier,      :type => String
  field :identifier_type, :type => String
  field :note,            :type => String
  field :symptoms,        :type => String
  field :sku,             :type => String,   :default => ->{ SecureRandom.hex(8).upcase }
  field :tax_rate,        :type => Float,    :default => 0
  
  index({ :account_id => 1, :serial => 1, :sku => 1 })
  
  attr_reader :quantity, :subtotal, :status, :tax, :total, :image
  
  before_validation { completed_at = Time.now.utc if complete }
  
  validates_inclusion_of    :complete, :in => [true, false]
  validates_inclusion_of    :flagged, :in => [true, false]
  validates_presence_of     :sku
  validates_uniqueness_of   :sku, scope: :account_id
  validates_presence_of     :payment, :store, :till, :user
  
  default_scope ->{ where(:account_id => Account.current_id) }
  
  scope :search, ->(query) { query ? full_text_search(query) : all }
  scope :sorted, ->(sort, order) {
    if sort
      order ||= 'ASC'
      order_by("#{sort} #{order}")
    else
      desc(:updated_at)
    end
  }
  scope :user_id, ->(user_id) { where(:user_id => user_id) if user_id }
  scope :customer_id, ->(customer_id) { where(:customer_id => customer_id) if customer_id }
  scope :location_id, ->(location_id) { where(:location_id => location_id) if location_id }
  scope :store_id, ->(store_id) { where(:store_id => store_id) if store_id }
  
  belongs_to  :account
  belongs_to  :customer
  embeds_many :images,      cascade_callbacks: true
  embeds_many :lines,       cascade_callbacks: true
  belongs_to  :location
  embeds_many :logs,        cascade_callbacks: true
  embeds_one  :payment,     cascade_callbacks: true
  belongs_to  :store
  belongs_to  :till
  belongs_to  :user
  
  after_save :_complete
  
  accepts_nested_attributes_for :lines,   :allow_destroy => true
  accepts_nested_attributes_for :logs,    :allow_destroy => true
  accepts_nested_attributes_for :payment
  
  search_in :sku, :identifier, :symptoms, :note, :logs => [:type, :note], :lines => [:title, :sku, :note], :store => [:name], :till => [:name], :customer => [:first_name, :last_name, :sku], :user => [:username, :email, :first_name, :last_name]
  
  liquid_methods :account, :complete, :completed_at, :created_at, :customer, :flagged, :identifier, :identifier_type, :lines, :location, :logs, :note, :quantity, :serial, :subtotal, :symptoms, :sku, :status, :store, :tax, :tax_rate, :total, :updated_at, :user
  
  def quantity
    quantity = 0
    lines.each do |line|
      quantity += line.quantity
    end
    quantity
  end
  
  def subtotal
    subtotal = 0
    lines.each do |line|
      subtotal += line.subtotal
    end
    subtotal
  end
  
  def subtotal_taxable
    subtotal_taxable = 0
    lines.each do |line|
      if line.taxable
        subtotal_taxable += line.subtotal
      end
    end
    subtotal_taxable
  end
  
  def tax
    tax = 0
    subtotal_taxable = self.subtotal_taxable
    if subtotal_taxable > 0
      tax += (subtotal_taxable * self.tax_rate).round
    end
    tax
  end
  
  def total
    self.subtotal + self.tax
  end
  
  def status
    self.logs.desc(:created_at).first.name unless self.logs.empty?
  end
  
  def image
    images.asc(:index).first
  end
  
  protected
  
  def _complete
    if complete && completed_at.nil?
      set(:completed_at, Time.now.utc)
    end
    true
  end
end