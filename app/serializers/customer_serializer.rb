class CustomerSerializer < ActiveModel::Serializer
  delegate :params, to: :scope
  
  attributes :id, :credit, :date_of_birth, :email, :first_name, :identifier, :identifier_type, :last_name, :notes, :organization, :sku, :created_at, :updated_at

  has_many :addresses
  has_many :certificates, :serializer => CertificateSerializer
  has_many :images
  has_many :phones
  has_many :purchases, :serializer => PurchaseSerializer
  has_many :repairs, :serializer => RepairSerializer
  has_many :sales, :serializer => SaleSerializer
  
  def certificates
    object.certificates.sorted(nil)
  end
  
  def purchases
    object.purchases.limit(5).sorted(nil)
  end
  
  def repairs
    object.repairs.limit(5).sorted(nil)
  end
  
  def sales
    object.sales.limit(5).sorted(nil)
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