class LineSerializer < ActiveModel::Serializer
  attributes :id, :certificate_id, :unit_id, :item_id, :amount, :amount_cash, :amount_credit, :bullets, :note, :quantity, :sku, :taxable, :title

  has_one :unit
  has_one :item
  has_one :certificate
end