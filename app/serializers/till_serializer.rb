class TillSerializer < ActiveModel::Serializer
  delegate :params, to: :scope
  
  attributes :id, :store_id, :user_id, :minimum, :balance, :name, :tax_rate, :created_at, :updated_at
  
  has_many :adjustments
  has_one :store, :serializer => StoreIndexSerializer
  has_one :user, :serializer => UserIndexSerializer
  
  def include_associations!
    include! :adjustments if params[:adjustments]
    include! :store
    include! :user
  end
end