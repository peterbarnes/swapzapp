class Template
  include Mongoid::Document
  include Mongoid::Search
  
  field :name,      :type => String
  field :body,      :type => String
  field :category,  :type => String
  
  validates_presence_of :name, :body, :category
  validates_inclusion_of :category, :in => ['certificate', 'customer', 'sale', 'purchase', 'repair']
  
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
  scope :categorized, ->(categorized) { where(:category => categorized) if categorized }
  
  embedded_in :account
  
  search_in :name, :category
  
  liquid_methods :name, :body, :category
end