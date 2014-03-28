class RepairSerializer < ActiveModel::Serializer
  delegate :params, to: :scope
  
  attributes :id, :customer_id, :location_id, :store_id, :till_id, :user_id, :complete, :flagged, :identifier, :identifier_type, :note, :symptoms, :sku, :tax, :tax_rate, :completed_at, :created_at, :updated_at
  
  has_one :customer
  has_many :images
  has_many :lines
  has_one  :location, :serializer => LocationIndexSerializer
  has_many :logs
  has_one  :payment
  has_one  :store, :serializer => StoreIndexSerializer
  has_one  :till, :serializer => TillIndexSerializer
  has_one  :user, :serializer => UserIndexSerializer
  
  def include_associations!
    include! :customer if params[:customer]
    include! :images
    include! :lines
    include! :location
    include! :logs
    include! :payment
    include! :store
    include! :till
    include! :user
  end
end