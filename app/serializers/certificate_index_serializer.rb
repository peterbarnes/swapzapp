class CertificateIndexSerializer < ActiveModel::Serializer
  delegate :params, to: :scope
  
  attributes :id, :customer_id, :active, :amount, :balance, :sku, :created_at, :updated_at
  
  has_one :customer, :serializer => CustomerIndexSerializer
  has_many :sales, :serializer => SaleIndexSerializer
  
  def include_associations!
    include! :customer if params[:customer]
    include! :sales if params[:sales]
  end
end