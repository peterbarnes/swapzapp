class StoreSerializer < ActiveModel::Serializer
  delegate :params, to: :scope
  
  attributes :id, :description, :legal, :name, :created_at, :updated_at
  
  has_one :address
  has_one :image
  has_many :locations, :serializer => LocationIndexSerializer
  has_many :phones
  has_many :purchases, :serializer => PurchaseIndexSerializer
  has_many :repairs, :serializer => RepairIndexSerializer
  has_many :sales, :serializer => SaleIndexSerializer
  has_many :tills, :serializer => TillIndexSerializer
  
  def include_associations!
    include! :address
    include! :image
    include! :locations if params[:locations]
    include! :phones
    include! :purchases if params[:purchases]
    include! :repairs if params[:repairs]
    include! :sales if params[:sales]
    include! :tills if params[:tills]
  end
end