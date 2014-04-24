class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Search
  
  field :active, :type => Boolean,        :default => true
  field :administrator, :type => Boolean, :default => false
  field :auth_token, :type => String,     :default => ->{ generate_token(:auth_token) }
  field :email, :type => String
  field :first_name, :type => String
  field :last_name, :type => String
  field :password_hash, :type => String
  field :password_salt, :type => String
  field :pin, :type => String,            :default => ->{ rand(10).to_s + rand(10).to_s + rand(10).to_s + rand(10).to_s }
  field :reset_token, :type => String,    :default => ->{ generate_token(:reset_token) }
  field :reset_time, :type => Time,       :default => ->{ Time.zone.now }
  field :time_zone,   :type => String,    :default => ->{ Time.zone.name }
  field :username, :type => String
  
  index({ :account_id => 1, :last_name => 1, :first_name => 1, :email => 1, :username => 1 })

  attr_accessor :password, :fullname
  
  validates_presence_of     :account
  validates_inclusion_of    :active, :in => [true, false]
  validates_inclusion_of    :administrator, :in => [true, false]
  validates_uniqueness_of   :auth_token
  validates_presence_of     :email
  validates_uniqueness_of   :email, :scope => :account_id
  validates                 :email, :email => true
  validates_presence_of     :first_name
  validates_presence_of     :last_name
  validates_presence_of     :password, :on => :create
  validates_confirmation_of :password
  validates_presence_of     :pin
  validates_inclusion_of    :time_zone, :in => ActiveSupport::TimeZone.all.map(&:name)
  validates_presence_of     :username
  validates_uniqueness_of   :username, scope: :account_id
  
  default_scope ->{ where(:account_id => Account.current_id) }
  
  scope :searched, ->(query) { query ? full_text_search(query) : all }
  scope :sorted, ->(sort, order) {
    if sort
      order ||= 'ASC'
      order_by("#{sort} #{order}")
    else
      asc(:last_name, :first_name)
    end
  }
  scope :clocked_in, ->(clocked_in) { 
    if clocked_in
      user_ids = Timecard.only(:user_id).where(:out => nil).map(&:user_id)
      where(:id.in => user_ids)
    else
      all
    end
  }
  scope :clocked_out, ->(clocked_out) { 
    if clocked_out
      user_ids = Timecard.only(:user_id).where(:out.ne => nil).map(&:user_id)
      where(:id.in => user_ids)
    else
      all
    end
  }
  
  before_save     :_encrypt_password

  belongs_to      :account
  has_many        :activities
  has_many        :purchases
  has_many        :repairs
  has_many        :sales
  has_many        :tills
  has_many        :timecards
  
  search_in :username, :email, :first_name, :last_name
  
  liquid_methods :active, :administrator, :email, :first_name, :fullname, :last_name, :time_zone, :username
  
  def self.authenticate(email, password)
    user = where(:email => email, :active => true).first
    if user && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)
      user
    else
      nil
    end
  end
  
  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while User.where(column => self[column]).exists?
  end
  
  def send_reset
    generate_token(:reset_token)
    self.reset_time = Time.now
    save!
    ResetMailer.reset(self).deliver
  end
  
  def fullname
    if first_name and last_name
      "#{first_name} #{last_name}"
    end
  end
  
  def gravatar_url(size=48)
    gravatar_id = Digest::MD5.hexdigest(self.email.downcase)
    "http://gravatar.com/avatar/#{gravatar_id}.png?s=#{size}"
  end

  private
  
  def _encrypt_password
    if self.password.present?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = BCrypt::Engine.hash_secret(self.password, self.password_salt)
    end
  end
end