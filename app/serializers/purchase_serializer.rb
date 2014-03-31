class PurchaseSerializer < ActiveModel::Serializer
  attributes :id, :customer_id, :store_id, :till_id, :user_id, :complete, :flagged, :sku, :note, :ratio, :completed_at, :created_at, :updated_at
  
  has_one :customer, :serializer => CustomerSerializer
  has_many :lines
  has_one :store, :serializer => StoreIndexSerializer
  has_one :till, :serializer => TillIndexSerializer
  has_one :user, :serializer => UserIndexSerializer
end