class Store
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Search
  
  field :description, :type => String
  field :legal,       :type => String
  field :name,        :type => String
  
  index({ :account_id => 1, :name => 1 })

  validates_presence_of   :name, :address
  
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

  belongs_to  :account
  embeds_one  :address,     cascade_callbacks: true
  embeds_one  :image,       cascade_callbacks: true
  has_many    :locations
  embeds_many :phones,      cascade_callbacks: true
  has_many    :purchases
  has_many    :repairs
  has_many    :sales
  has_many    :tills
  
  accepts_nested_attributes_for :address, :allow_destroy => true
  accepts_nested_attributes_for :image, :allow_destroy => true
  accepts_nested_attributes_for :phones, :allow_destroy => true
  
  search_in :name, :description, :address => [:first_line, :city], :phones => [:number]
  
  liquid_methods :created_at, :description, :legal, :name, :address, :image, :locations, :phones, :purchases, :repairs, :sales, :tills, :updated_at
end