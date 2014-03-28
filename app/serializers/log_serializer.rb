class LogSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :name, :note, :created_at, :updated_at
  
  has_one :user, :serializer => UserIndexSerializer
end