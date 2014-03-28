class RepairSerializer < ActiveModel::Serializer
  attributes :id, :customer_id, :location_id, :store_id, :till_id, :user_id, :complete, :flagged, :identifier, :identifier_type, :note, :symptoms, :sku, :tax, :tax_rate, :completed_at, :created_at, :updated_at
  
  has_one :customer
  has_many :images
  has_many :lines
  has_one  :location, :serializer => LocationIndexSerializer
  has_many :logs
  has_one  :payment
  has_one  :store, :serializer => StoreIndexSerializer
  has_one  :till, :serializer => TillIndexSerializer
  has_one  :user, :serializer => UserIndexSerializer
end