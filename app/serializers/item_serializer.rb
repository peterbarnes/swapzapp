class ItemSerializer < ActiveModel::Serializer
  attributes :id, :inventory_id, :description, :identifier, :identifier_type, :manufacturer, :name, :price, :price_cash, :price_credit, :saleable, :sku, :taxable, :created_at, :updated_at

  has_many :components
  has_many :conditions
  has_many :images
  has_one  :inventory, :serializer => InventoryIndexSerializer
  has_many :props
  has_many :tags
  has_many :variants
end