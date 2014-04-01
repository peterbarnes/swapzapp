class Adjustment
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Search
  
  field :amount,      :type => Integer,   :default => 0
  field :balance,     :type => Integer,   :default => 0
  field :description, :type => String
  field :title,       :type => String
  
  validates_presence_of   :amount, :balance, :user
  
  scope :search, ->(query) { query ? full_text_search(query) : all }
  scope :sorted, ->(sort) {
    if sort
      sort[:asc] ||= []
      sort[:desc] ||= []
      asc(sort[:asc]).desc(sort[:desc])
    else
      desc(:created_at)
    end
  }
  scope :user_id, ->(user_id) { where(:user_id => user_id) unless user_id.nil? }
  
  embedded_in              :till
  belongs_to               :user
  
  search_in  :description, :title, :till => [:name], :user => [:username, :email, :first_name, :last_name]
  
  liquid_methods :amount, :balance, :description, :title, :user
  
  after_save do
    till.set(:balance, till.adjustment_balance)
    true
  end
end