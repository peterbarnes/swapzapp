class Location
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Ancestry
  include Mongoid::Search
  
  field :description, :type => String
  field :name, :type => String
  field :restock, :type => Integer,  :default => 0
  field :sku, :type => String, :default => ->{ SecureRandom.hex(8).upcase }
  field :target, :type => Integer,  :default => 0
  
  index({ :account_id => 1, :name => 1, :sku => 1 })
    
  has_ancestry
  
  default_scope ->{ where(:account_id => Account.current_id) }
  
  scope :search, ->(query) { query ? full_text_search(query) : all }
  scope :sorted, ->(sort) {
    if sort
      sort[:asc] ||= []
      sort[:desc] ||= []
      asc(sort[:asc]).desc(sort[:desc])
    else
      asc(:name)
    end
  }
  scope :store_id, ->(store_id) { roots.where(:store_id => store_id) if store_id }
  
  validates_presence_of     :name, :sku
  validates_uniqueness_of   :sku, scope: :account_id

  belongs_to  :account
  embeds_one  :image, cascade_callbacks: true
  has_many    :repairs
  belongs_to  :store
  has_many    :units
  
  accepts_nested_attributes_for :image, :allow_destroy => true
  
  search_in :name, :description, :sku
  
  liquid_methods :created_at, :description, :name, :restock, :sku, :target, :repairs, :store, :units, :updated_at
end