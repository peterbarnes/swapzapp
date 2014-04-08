class Log
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Search
  
  field :name,    :type => String
  field :note,    :type => String
  
  scope :search, ->(query) { query ? full_text_search(query) : all }
  scope :sorted, ->(sort, order) {
    if sort
      order ||= 'ASC'
      order_by("#{sort} #{order}")
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