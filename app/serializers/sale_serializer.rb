class SaleSerializer < ActiveModel::Serializer
  delegate :params, to: :scope
  
  attributes :id, :certificate_id, :customer_id, :store_id, :till_id, :user_id, :complete, :flagged, :sku, :note, :tax_rate, :credit_balance, :completed_at, :created_at, :updated_at

  has_one :certificate
  has_one :customer, :serializer => CustomerIndexSerializer
  has_many :lines
  has_one :payment
  has_one :store, :serializer => StoreIndexSerializer
  has_one :till, :serializer => TillIndexSerializer
  has_one :user, :serializer => UserIndexSerializer
end