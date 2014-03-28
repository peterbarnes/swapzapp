class UserIndexSerializer < ActiveModel::Serializer
  delegate :params, to: :scope
  
  attributes :id, :active, :administrator, :email, :first_name, :gravatar_url, :last_name, :pin, :time_zone, :username, :created_at, :updated_at
  
  has_many :tills, :serializer => TillIndexSerializer
  has_many :timecards, :serializer => TimecardIndexSerializer
  
  def gravatar_url
    gravatar_id = Digest::MD5.hexdigest(object.email.downcase)
    "http://gravatar.com/avatar/#{gravatar_id}.png"
  end
  
  def include_associations!
    include! :tills if params[:tills]
    include! :timecards if params[:timecards]
  end
end