class ItemIndexSerializer < ActiveModel::Serializer
  delegate :params, to: :scope
  
  attributes :id, :inventory_id, :description, :identifier, :identifier_type, :manufacturer, :name, :price, :price_cash, :price_credit, :saleable, :sku, :taxable, :created_at, :updated_at

  has_many :components
  has_many :conditions
  has_many :images
  has_one  :inventory, :serializer => InventoryIndexSerializer
  has_many :props
  has_many :tags
  has_many :variants
  
  def include_associations!
    include! :components if params[:components]
    include! :conditions if params[:conditions]
    include! :images
    include! :inventory if params[:inventory]
    include! :props if params[:props]
    include! :tags if params[:tags]
    include! :variants if params[:variants]
  end
end