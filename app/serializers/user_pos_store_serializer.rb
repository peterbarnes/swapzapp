class UserPosStoreSerializer < ActiveModel::Serializer
  attributes :id, :description, :legal, :name, :created_at, :updated_at
  
  has_one :address
  has_one :image
  has_many :phones
end