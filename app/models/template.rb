class Template
  include Mongoid::Document
  include Mongoid::Search
  
  field :name,      :type => String
  field :body,      :type => String
  field :category,  :type => String
  field :primary,   :type => Boolean, :default => false
  
  validates_presence_of :name, :body, :category
  validates_inclusion_of :category, :in => ['certificate', 'customer', 'sale', 'purchase', 'repair']
  
  scope :searched, ->(query) { query ? full_text_search(query) : all }
  scope :sorted, ->(sort, order) {
    if sort
      order ||= 'ASC'
      order_by("#{sort} #{order}")
    else
      asc(:name)
    end
  }
  scope :categorized, ->(categorized) { where(:category => categorized) if categorized }
  
  embedded_in :account
  
  search_in :name, :category
  
  liquid_methods :name, :body, :category
  
  def set_primary
    self.account.templates.where(:category => category).each do |t|
      t.update_attribute(:primary, false)
    end
    self.update_attribute(:primary, true)
  end
end