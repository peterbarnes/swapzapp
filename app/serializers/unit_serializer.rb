class UnitSerializer < ActiveModel::Serializer
  attributes :id, :item_id, :variant_id, :filing_formatted, :price, :quantity, :sku, :taxable, :calculated, :name, :created_at, :updated_at
  
  has_many  :components
  has_many  :conditions
  has_one   :item
  has_one   :variant
  
  def taxable
    object.item.taxable if object.item
  end
end