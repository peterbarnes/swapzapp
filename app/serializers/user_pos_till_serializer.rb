class UserPosTillSerializer < ActiveModel::Serializer
  attributes :id, :store_id, :user_id, :minimum, :balance, :name, :tax_rate, :created_at, :updated_at
  
  has_one :store, :serializer => UserPosStoreSerializer
end