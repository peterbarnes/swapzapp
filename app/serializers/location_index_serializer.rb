class LocationIndexSerializer < ActiveModel::Serializer
  delegate :params, to: :scope
  
  attributes :id, :store_id, :description, :name, :restock, :sku, :target, :created_at, :updated_at
  
  has_one :image
  has_one :store, :serializer => StoreIndexSerializer
  
  def include_associations!
    include! :store if params[:store]
  end
end