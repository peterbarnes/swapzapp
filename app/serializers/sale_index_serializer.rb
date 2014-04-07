class SaleIndexSerializer < ActiveModel::Serializer
  delegate :params, to: :scope
  
  attributes :id, :certificate_id, :customer_id, :store_id, :till_id, :user_id, :complete, :flagged, :sku, :note, :tax_rate, :credit_balance, :completed_at, :created_at, :updated_at

  has_one :certificate, :serializer => CertificateIndexSerializer
  has_one :customer, :serializer => CustomerIndexSerializer
  has_many :lines
  has_one :payment
  has_one :store, :serializer => StoreIndexSerializer
  has_one :till, :serializer => TillIndexSerializer
  has_one :user, :serializer => UserIndexSerializer
  
  def include_associations!
    include! :certificate if params[:certificate]
    include! :customer if params[:customer]
    include! :lines if params[:lines]
    include! :payment if params[:payment]
    include! :store if params[:store]
    include! :till if params[:till]
    include! :user if params[:user]
  end
end