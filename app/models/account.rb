class Account
  include Mongoid::Document
  include Mongoid::Timestamps
  
  RESERVED_TOKENS = %w(
    admin api app assets blog calendar demo developer developers docs files ftp git lab mail manage pages pos sites ssl staging status support www
  )
  
  field :api_active,                :type => Boolean,   :default => true
  field :api_secret,                :type => String,    :default => ->{ UUID.generate(:compact) }
  field :title,                     :type => String
  field :token,                     :type => String,    :default => ->{ UUID.generate(:compact) }
  
  validates_presence_of     :token, :api_secret
  validates_uniqueness_of   :token
  validates_format_of       :token, :with => /\A[a-z0-9_]+\z/, 
                                    :message => "must contain only lowercase letters, numbers and underscores."
  validates_exclusion_of    :token, :in => RESERVED_TOKENS, :message => "Token %{value} is reserved."
  validates_length_of       :api_secret,  :is => 32

  has_many :activities,   :dependent => :destroy
  has_many :certificates, :dependent => :destroy
  has_many :components,   :dependent => :destroy
  has_many :conditions,   :dependent => :destroy
  has_many :customers,    :dependent => :destroy
  has_many :inventories,  :dependent => :destroy
  has_many :items,        :dependent => :destroy
  has_many :locations,    :dependent => :destroy
  has_many :purchases,    :dependent => :destroy
  has_many :repairs,      :dependent => :destroy
  has_many :reports,      :dependent => :destroy
  has_many :tills,        :dependent => :destroy
  has_many :timecards,    :dependent => :destroy
  has_many :sales,        :dependent => :destroy
  has_many :stores,       :dependent => :destroy
  has_many :units,        :dependent => :destroy
  has_many :users,        :dependent => :destroy
  has_many :variants,     :dependent => :destroy
  
  embeds_many :templates
  
  liquid_methods :title, :token
  
  def self.current_id=(id)
    Thread.current[:current_id] = id
  end

  def self.current_id
    Thread.current[:current_id]
  end
  
  def set_current
    self.class.current_id = self.id
  end
  
  def namespace
    Digest::SHA256.hexdigest self.id.to_s + self.api_secret
  end

  def records
    count = 0
    self.associations.keys.each do |relation|
      count += self.send(relation.to_s).count
    end
    return count
  end
  
  def reset!
    self.associations.keys.each do |relation|
      self.send(relation.to_s).destroy_all
    end
    self.save
  end

  def regenerate_api_secret
    self.update_attribute(:api_secret, UUID.generate(:compact))
  end
end