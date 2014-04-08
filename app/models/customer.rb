class Customer
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::MultiParameterAttributes
  include Mongoid::Search
  
  field :credit, :type => Integer,  :default => 0
  field :date_of_birth, :type => Date, :default => ->{ Date.current }
  field :email, :type => String
  field :first_name, :type => String
  field :identifier, :type => String
  field :identifier_type, :type => String
  field :last_name, :type => String
  field :notes, :type => String
  field :organization, :type => String
  field :sku, :type => String, :default => ->{ SecureRandom.hex(8).upcase }
  
  index({ :account_id => 1, :email => 1, :first_name => 1, :last_name => 1, :identifier => 1, :sku => 1 })

  attr_reader :fullname, :image
  
  validates_presence_of     :credit
  validates_presence_of     :first_name
  validates_presence_of     :last_name
  validates_presence_of     :sku
  validates_uniqueness_of   :sku, scope: :account_id
  
  default_scope ->{ where(:account_id => Account.current_id) }
  
  scope :search, ->(query) { query ? full_text_search(query) : all }
  scope :sorted, ->(sort, order) {
    if sort
      order ||= 'ASC'
      order_by("#{sort} #{order}")
    else
      asc(:last_name, :first_name)
    end
  }
  
  belongs_to    :account
  embeds_many   :addresses, cascade_callbacks: true
  has_many      :certificates
  embeds_many   :images,    cascade_callbacks: true
  embeds_many   :phones,    cascade_callbacks: true
  has_many      :purchases
  has_many      :repairs
  has_many      :sales
  
  accepts_nested_attributes_for :addresses, :allow_destroy => true
  accepts_nested_attributes_for :images, :allow_destroy => true
  accepts_nested_attributes_for :phones, :allow_destroy => true
  
  search_in :email, :first_name, :last_name, :notes, :organization, :sku, :addresses => [:first_line, :city], :phones => [:number]
  
  liquid_methods :credit, :created_at, :date_of_birth, :email, :fullname, :first_name, :identifier, :identifier_type, :last_name, :notes, :organization, :sku, :addresses, :certificates, :phones, :purchases, :repairs, :sales
  
  def name
    fullname
  end
  
  def fullname
    if first_name and last_name
      "#{first_name} #{last_name}"
    end
  end
  
  def image
    images.asc(:index).first
  end
  
  def add_credit(amount)
    update_attribute(:credit, credit + amount) if amount.is_a?(Integer)
  end
  
  def subtract_credit(amount)
    update_attribute(:credit, credit - amount) if amount.is_a?(Integer)
  end
end