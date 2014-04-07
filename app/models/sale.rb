class Sale
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Search
  
  field :complete,        :type => Boolean,   :default => false
  field :completed_at,    :type => Time
  field :flagged,         :type => Boolean,   :default => false
  field :note,            :type => String
  field :sku,             :type => String,    :default => ->{ SecureRandom.hex(8).upcase }
  field :tax_rate,        :type => Float,     :default => 0
  field :credit_balance,  :type => Integer,   :default => 0
  
  index({ :account_id => 1, :sku => 1 })
  
  attr_reader :quantity, :subtotal, :subtotal_taxable, :subtotal_after_store_credit, :subtotal_taxable_after_store_credit, :tax, :total, :due
  
  validates_inclusion_of    :complete,  :in => [true, false]
  validates_inclusion_of    :flagged,   :in => [true, false]
  validates_presence_of     :sku
  validates_uniqueness_of   :sku, scope: :account_id
  validates_presence_of     :tax_rate
  validates_inclusion_of    :complete, :in => [true, false]
  validates_presence_of     :payment, :store, :till, :user
  
  default_scope ->{ where(:account_id => Account.current_id) }
  
  scope :search, ->(query) { query ? full_text_search(query) : all }
  scope :sorted, ->(sort) {
    if sort
      sort[:asc] ||= []
      sort[:desc] ||= []
      asc(sort[:asc]).desc(sort[:desc])
    else
      desc(:updated_at)
    end
  }
  scope :user_id, ->(user_id) { where(:user_id => user_id) if user_id }
  scope :customer_id, ->(customer_id) { where(:customer_id => customer_id) if customer_id }
  scope :store_id, ->(store_id) { where(:store_id => store_id) if store_id }
  scope :till_id, ->(till_id) { where(:till_id => till_id) if till_id }
  
  belongs_to  :account
  belongs_to  :certificate
  belongs_to  :customer
  embeds_many :lines,   cascade_callbacks: true
  embeds_one  :payment, cascade_callbacks: true
  belongs_to  :store
  belongs_to  :till
  belongs_to  :user
  
  after_save :_complete
  
  accepts_nested_attributes_for :lines, :allow_destroy => true
  accepts_nested_attributes_for :payment
  
  search_in :sku, :note, :lines => [:title, :sku, :note], :certificate => [:sku], :customer => [:first_name, :last_name, :sku], :till => [:name], :store => [:name], :user => [:username, :email, :first_name, :last_name]
  
  liquid_methods :account, :created_at, :certificate, :credit_balance, :complete, :completed_at, :customer, :flagged, :lines, :payment, :note, :sku, :quantity, :subtotal, :subtotal_taxable, :subtotal_after_store_credit, :subtotal_taxable_after_store_credit, :tax, :tax_rate, :total, :store, :till, :user, :due, :updated_at
  
  def self.trend(now, period_in_days)
    
    map = %Q{
      function() {
        var oneDay = 24*60*60*1000;
        var now = new Date();
        var date = new Date(this.completed_at);

        var days_ago = Math.round(Math.abs((now.getTime() - date.getTime())/(oneDay))) * -1;
        
        var quantity = 0;
        var subtotal = 0;
        var subtotal_taxable = 0;
        var payment = this.payment
        if (this.lines) {
          this.lines.forEach(function(line) {
            quantity += line.quantity;
            subtotal += line.quantity * line.amount;
            if (line.taxable) {
              subtotal_taxable += line.quantity * line.amount;
            }
          });
        }
        var subtotal_after_store_credit = subtotal - payment.store_credit;
        var subtotal_taxable_after_store_credit = subtotal_taxable - payment.store_credit;
        var tax = 0;
        if (subtotal_taxable_after_store_credit > 0) {
          tax += Math.round(subtotal_taxable_after_store_credit * this.tax_rate);
        }
        var total = subtotal_after_store_credit + tax;
        
        emit(days_ago, {count: 1, quantity: quantity, total: total});
      }
    }

    reduce = %Q{
      function(key, values) {
        var result = {count: 0, quantity: 0, total: 0};
        values.forEach(function(value) {
          result.count += value.count;
          result.quantity += value.quantity;
          result.total += value.total;
        });
        return result;
      }
    }
    
    @sales = Sale.where(:complete => true, :completed_at.gte => now.beginning_of_day - period_in_days.to_i.days)
    
    @result = []
    unless @sales.empty?
      @data = @sales.map_reduce(map, reduce).out(inline: true)
      ((period_in_days.to_i * -1)..0).each do |day|
        @point = @data.find{|d| d['_id'] == day}
        if @point
          @result << { day: day, count: @point["value"]["count"], quantity: @point["value"]["quantity"], total: @point["value"]["total"] }
        else
          @result << { day: day, count: 0, quantity: 0, total: 0 }
        end
      end
    else
      ((period_in_days.to_i * -1)..0).each do |day|
        @result << { day: day, count: 0, quantity: 0, total: 0 }
      end
    end
    
    @result
  end
  
  def quantity
    quantity = 0
    lines.each do |line|
      quantity += line.quantity
    end
    quantity
  end
  
  def subtotal
    subtotal = 0
    lines.each do |line|
      subtotal += line.subtotal
    end
    subtotal
  end
  
  def subtotal_taxable
    subtotal_taxable = 0
    lines.each do |line|
      if line.taxable
        subtotal_taxable += line.subtotal
      end
    end
    subtotal_taxable
  end
  
  def subtotal_after_store_credit
    subtotal_after = self.subtotal
    if self.payment
      subtotal_after -= self.payment.store_credit
    end
    subtotal_after
  end
  
  def subtotal_taxable_after_store_credit
    subtotal_taxable_after = self.subtotal_taxable
    if self.payment
      subtotal_taxable_after -= self.payment.store_credit
    end
    subtotal_taxable_after
  end
  
  def tax
    tax = 0
    subtotal_taxable_after_store_credit = self.subtotal_taxable_after_store_credit
    if subtotal_taxable_after_store_credit > 0
      tax += (subtotal_taxable_after_store_credit * self.tax_rate).round
    end
    tax
  end
  
  def total
    self.subtotal_after_store_credit + self.tax
  end
  
  def due
    if self.payment
      self.total - self.payment.total
    else
      self.total
    end
  end
  
  protected
  
  def _complete
    if complete && completed_at.nil?
      if till && payment && user
        title = "Sale #{sku} #{Time.now.to_s} (#{user.fullname})"
        till.adjustments.create(:title => title, :amount => payment.cash + due, :balance => till.balance, :user => user)
      end
      if certificate && payment
        certificate.subtract_balance(payment.gift_card) if payment.gift_card > 0
      end
      if customer && payment
        customer.subtract_credit(payment.store_credit) if payment.store_credit > 0
        set(:credit_balance, customer.credit)
      end
      lines.each do |line|
        if line.unit
          line.unit.subtract_quantity(line.quantity) if line.quantity > 0
        end
        if line.certificate
          line.certificate.update_attributes(:active => true, :customer => customer)
        end
      end
      set(:completed_at, Time.now.utc)
    end
    true
  end
end