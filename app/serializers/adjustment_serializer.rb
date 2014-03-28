class AdjustmentSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :amount, :balance, :description, :title, :created_at, :updated_at
  
  has_one :user, :serializer => UserIndexSerializer
end