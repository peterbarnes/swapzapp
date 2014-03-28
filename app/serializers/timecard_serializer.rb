class TimecardSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :flagged, :in, :note, :out, :hours, :created_at, :updated_at
  
  has_one :user
end