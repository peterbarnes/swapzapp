class Inventory
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Search
  
  field :description, :type => String
  field :name,        :type => String
  
  index({ :account_id => 1, :name => 1 })
  
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
  has_many    :items
  
  validates_presence_of :name
  
  search_in :name, :description
  
  liquid_methods :description, :name, :created_at, :updated_at, :items
end