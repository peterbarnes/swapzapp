class Activity
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Search
  
  field :name,   :type => String
  field :action, :type => String
  
  index({ :account_id => 1, :name => 1 })
  
  validates_presence_of :action
  
  default_scope ->{ where(:account_id => Account.current_id) }
  
  scope :searched, ->(query) { query ? full_text_search(query) : all }
  scope :sorted, ->(sort, order) {
    if sort
      order ||= 'ASC'
      order_by("#{sort} #{order}")
    else
      desc(:created_at)
    end
  }
  scope :user_id, ->(user_id) { where(:user_id => user_id) if user_id }
  
  belongs_to :account
  belongs_to :trackable, :polymorphic => true
  belongs_to :user
  
  search_in :name, :action, :user => [:first_name, :last_name, :username]
  
  liquid_methods :name, :action, :created_at, :updated_at, :trackable, :user
end