class Timecard
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Search
  include Mongoid::MultiParameterAttributes
  
  field :flagged,   :type => Boolean, :default => false
  field :in,        :type => Time,    :default => ->{ Time.now.utc }
  field :note,      :type => String
  field :out,       :type => Time
  
  attr_reader :name, :clocked_in, :clocked_out, :hours
  
  index({ :account_id => 1 })
  
  default_scope ->{ where(:account_id => Account.current_id) }
  
  scope :searched, ->(query) { query ? full_text_search(query) : all }
  scope :sorted, ->(sort, order) {
    if sort
      order ||= 'ASC'
      order_by("#{sort} #{order}")
    else
      desc(:flagged).desc(:in).asc(:user_id)
    end
  }
  scope :user_id, ->(user_id) { where(:user_id => user_id) if user_id }
  
  validates_presence_of :user
  
  belongs_to :account
  belongs_to :user
  
  search_in :note, :user => [:first_name, :last_name, :username]
  
  liquid_methods :created_at, :clocked_in, :clocked_out, :flagged, :hours, :in, :note, :out, :updated_at, :user
  
  def clocked_in
    self.out.nil?
  end
  
  def clocked_out
    !clocked_in
  end
  
  def hours
    if clocked_out
      ((self.out - self.in) / 1.hour)
    else
      ((Time.now.utc - self.in) / 1.hour)
    end
  end
  
  def name
    self.id.to_s
  end
end