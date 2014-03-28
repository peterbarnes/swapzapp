class UserPosSerializer < ActiveModel::Serializer
  attributes :id, :active, :administrator, :email, :first_name, :gravatar_url, :last_name, :pin, :time_zone, :username, :created_at, :updated_at
  
  has_many :tills, :serializer => UserPosTillSerializer
  has_many :timecards, :serializer => UserPosTimecardSerializer
  
  def tills
    object.tills.asc(:name)
  end
  
  def timecards
    object.timecards.where(:in.gte => 7.days.ago).desc(:in)
  end
end