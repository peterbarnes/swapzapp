class Log
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Search
  
  field :name,    :type => String
  field :note,    :type => String
  
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
  
  validates_presence_of         :name
  
  embedded_in     :repair
  belongs_to      :user
  
  search_in  :name, :note, :user => [:username, :email, :first_name, :last_name]
  
  liquid_methods :created_at, :name, :note, :updated_at, :user
end