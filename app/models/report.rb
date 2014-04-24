class Report
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::MultiParameterAttributes
  include Mongoid::Paperclip
  include Mongoid::Search
  
  field :complete,  :type => Boolean, :default => false
  field :from,      :type => Date,    :default => ->{ Date.current }
  field :name,      :type => String
  field :to,        :type => Date,    :default => ->{ Date.current }
  field :job,       :type => String
  
  index({ :account_id => 1, :name => 1, :type => 1 })
  
  has_mongoid_attached_file :file
  
  validates_presence_of     :from
  validates_presence_of     :to
  validates_presence_of     :job
  
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

  belongs_to    :account
  
  search_in :name, :job
  
  liquid_methods :complete, :created_at, :file, :from, :name, :to, :job, :updated_at
end