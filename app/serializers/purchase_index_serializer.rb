class PurchaseIndexSerializer < ActiveModel::Serializer
  delegate :params, to: :scope
  
  attributes :id, :customer_id, :store_id, :till_id, :user_id, :complete, :flagged, :sku, :note, :ratio, :completed_at, :created_at, :updated_at
  
  has_one :customer, :serializer => CustomerIndexSerializer
  has_many :lines
  has_one :store, :serializer => StoreIndexSerializer
  has_one :till, :serializer => TillIndexSerializer
  has_one :user, :serializer => UserIndexSerializer
  
  def include_associations!
    include! :customer if params[:customer]
    include! :lines if params[:lines]
    include! :store if params[:store]
    include! :till if params[:till]
    include! :user if params[:user]
  end
end