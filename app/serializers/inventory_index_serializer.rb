class InventoryIndexSerializer < ActiveModel::Serializer
  delegate :params, to: :scope
  
  attributes :id, :name, :description, :created_at, :updated_at
  
  has_many :items, :serializer => ItemIndexSerializer
  
  def include_associations!
    include! :items if params[:items]
  end
end