class Unit
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Search
  include Mongoid::Autoinc
  
  field :price, :type => Integer,       :default => 0
  field :quantity, :type => Integer,    :default => 1
  field :sku, :type => String,          :default => ->{ SecureRandom.hex(6).upcase }
  field :calculated, :type => Boolean,  :default => true
  field :filing, :type => Integer,      :default => 0
  
  index({ :account_id => 1, :sku => 1})
  
  increments :filing,    :scope => :account_id
  
  attr_reader :price_calculated, :name
  
  validates_presence_of     :sku, :price, :quantity, :item, :location
  validates_uniqueness_of   :sku, scope: :account_id
  
  default_scope ->{ where(:account_id => Account.current_id) }
  
  scope :searched, ->(query) { query ? full_text_search(query) : all }
  scope :sorted, ->(sort, order) {
    if sort
      order ||= 'ASC'
      order_by("#{sort} #{order}")
    else
      asc(:sku)
    end
  }
  scope :location_id, ->(location_id) { where(:location_id => location_id) if location_id }
  scope :item_id, ->(item_id) { where(:item_id => item_id) if item_id }
  scope :variant_id, ->(variant_id) { where(:variant_id => variant_id) if variant_id }
  
  belongs_to                    :account
  has_and_belongs_to_many       :components
  has_and_belongs_to_many       :conditions
  belongs_to                    :item
  belongs_to                    :location
  belongs_to                    :variant
  
  search_in :sku, :item => [:sku, :name, :handle, :description]
  
  liquid_methods :calculated, :created_at, :components, :conditions, :filing, :filing_formatted, :item, :location, :name, :price, :price_calculated, :quantity, :sku, :updated_at, :variant
  
  def name
    if item
      item.name
    end
  end
  
  def filing_formatted(digit=7)
    return sprintf('%0' + digit.to_s + 'd', filing).insert(3, ' ')
  end
  
  def price_calculated
    if item
      calculated_price = item.price
      item.components.each do |component|
        if component.typical && !components.include?(component)
          calculated_price -= component.adjuster(item.price)
        end
        if !component.typical && components.include?(component)
          calculated_price += component.adjuster(item.price)
        end
      end
      item.conditions.each do |condition|
        calculated_price += condition.adjuster(item.price) if conditions.include?(condition)
      end
      calculated_price += variant.adjuster(item.price) if variant
      calculated_price
    else
      0
    end
  end
  
  def add_quantity(amount)
    update_attribute(:quantity, quantity + amount) if amount.is_a?(Integer)
  end
  
  def subtract_quantity(amount)
    update_attribute(:quantity, quantity - amount) if amount.is_a?(Integer)
  end
end