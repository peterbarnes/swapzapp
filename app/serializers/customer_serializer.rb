class CustomerSerializer < ActiveModel::Serializer
  delegate :params, to: :scope
  
  attributes :id, :credit, :date_of_birth, :email, :first_name, :identifier, :identifier_type, :last_name, :notes, :organization, :sku, :created_at, :updated_at

  has_many :addresses
  has_many :certificates, :serializer => CertificateIndexSerializer
  has_many :images
  has_many :phones
  has_many :purchases, :serializer => PurchaseIndexSerializer
  has_many :repairs, :serializer => RepairIndexSerializer
  has_many :sales, :serializer => SaleIndexSerializer
  
  def certificates
    object.certificates.sorted(nil, nil)
  end
  
  def purchases
    object.purchases.limit(5).sorted(nil, nil)
  end
  
  def repairs
    object.repairs.limit(5).sorted(nil, nil)
  end
  
  def sales
    object.sales.limit(5).sorted(nil, nil)
  end
    
  def include_associations!
    include! :addresses
    include! :certificates if params[:certificates]
    include! :images
    include! :phones
    include! :purchases if params[:purchases]
    include! :repairs if params[:repairs]
    include! :sales if params[:sales]
  end
end