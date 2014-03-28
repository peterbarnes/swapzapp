class UserSerializer < ActiveModel::Serializer
  delegate :params, to: :scope
  
  attributes :id, :active, :administrator, :email, :first_name, :gravatar_url, :last_name, :pin, :time_zone, :username, :created_at, :updated_at
  
  has_many :tills, :serializer => TillIndexSerializer
  has_many :timecards, :serializer => TimecardIndexSerializer
  
  def include_associations!
    include! :tills if params[:tills]
    include! :timecards if params[:timecards]
  end
end