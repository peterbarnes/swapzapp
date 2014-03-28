class LocationSerializer < ActiveModel::Serializer
  attributes :id, :store_id, :description, :name, :restock, :sku, :target, :created_at, :updated_at
  
  has_one :image
  has_one :store, :serializer => StoreIndexSerializer
end