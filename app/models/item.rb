class Item
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Search
  
  field :depth, :type => Float,    :default => 0
  field :description, :type => String
  field :dimension_measure, :type => String,   :default => 'in'
  field :flagged, :type => Boolean, :default => false
  field :height, :type => Float,    :default => 0
  field :identifier, :type => String
  field :identifier_type, :type => String, :default => 'UPC'
  field :manufacturer, :type => String
  field :name, :type => String
  field :price, :type => Integer,  :default => 0
  field :price_cash, :type => Integer,  :default => 0
  field :price_credit, :type => Integer,  :default => 0
  field :saleable, :type => Boolean, :default => false
  field :sku, :type => String, :default => ->{ SecureRandom.hex(8).upcase }
  field :taxable, :type => Boolean,  :default => true
  field :weight, :type => Float,    :default => 0
  field :weight_measure, :type => String,   :default => 'lb'
  field :width, :type => Float,    :default => 0
  
  attr_reader :image
  
  index({ :account_id => 1, :name => 1, :identifier => 1, :sku => 1 })

  validates_presence_of         :price, :price_cash, :price_credit, :sku, :inventory
  validates_inclusion_of        :flagged, :in => [true, false]
  validates_inclusion_of        :taxable, :in => [true, false]
  validates_uniqueness_of       :sku, scope: :account_id
  
  default_scope ->{ where(:account_id => Account.current_id) }
  
  scope :searched, ->(query) { query ? full_text_search(query) : all }
  scope :sorted, ->(sort, order) {
    if sort
      order ||= 'ASC'
      order_by("#{sort} #{order}")
    else
      asc(:name)
    end
  }
  scope :inventory_id, ->(inventory_id) { where(:inventory_id => inventory_id) if inventory_id }

  belongs_to                    :account
  has_many                      :components,  :dependent => :destroy
  has_many                      :conditions,  :dependent => :destroy
  embeds_many                   :images,      cascade_callbacks: true
  belongs_to                    :inventory
  embeds_many                   :props,       cascade_callbacks: true
  embeds_many                   :tags,        cascade_callbacks: true
  has_many                      :units,       :dependent => :destroy
  has_many                      :variants,    :dependent => :destroy
  
  accepts_nested_attributes_for :components, :allow_destroy => true
  accepts_nested_attributes_for :conditions, :allow_destroy => true
  accepts_nested_attributes_for :images, :allow_destroy => true
  accepts_nested_attributes_for :tags, :allow_destroy => true
  accepts_nested_attributes_for :props, :allow_destroy => true
  accepts_nested_attributes_for :variants, :allow_destroy => true
  
  search_in :name, :manufacturer, :identifier, :description, :sku, :variants => [:identifier]
  
  liquid_methods :created_at, :depth, :description, :dimension_measure, :flagged, :height, :identifier, :identifier_type, :manufacturer, :name, :price, :price_cash, :price_credit, :saleable, :sku, :taxable, :weight, :weight_measure, :width, :components, :conditions, :inventory, :props, :tags, :updated_at, :units, :variants

  def image
    images.asc(:index).first
  end
end