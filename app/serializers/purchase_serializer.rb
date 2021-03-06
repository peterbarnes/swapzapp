class PurchaseSerializer < ActiveModel::Serializer
  attributes :id, :customer_id, :store_id, :till_id, :user_id, :complete, :flagged, :sku, :note, :ratio, :credit_balance, :completed_at, :created_at, :updated_at
  
  has_one :customer, :serializer => CustomerIndexSerializer
  has_many :lines
  has_one :store, :serializer => StoreIndexSerializer
  has_one :till, :serializer => TillIndexSerializer
  has_one :user, :serializer => UserIndexSerializer
end