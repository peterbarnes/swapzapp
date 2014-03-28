class UnitIndexSerializer < ActiveModel::Serializer
  delegate :params, to: :scope
  
  attributes :id, :item_id, :variant_id, :filing_formatted, :price, :quantity, :sku, :taxable, :calculated, :name, :created_at, :updated_at
  
  has_many  :components
  has_many  :conditions
  has_one   :item
  has_one   :variant
  
  def taxable
    object.item.taxable if object.item
  end
  
  def include_associations!
    include! :components if params[:components]
    include! :conditions if params[:conditions]
    include! :item if params[:item]
    include! :variant if params[:variant]
  end
end