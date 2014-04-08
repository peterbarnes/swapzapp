class Purchase
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Search
  
  field :complete,        :type => Boolean,  :default => false
  field :completed_at,    :type => Time
  field :flagged,         :type => Boolean,  :default => false
  field :note,            :type => String
  field :sku,             :type => String,   :default => ->{ SecureRandom.hex(8).upcase }
  field :ratio,           :type => Float,    :default => 1
  field :credit_balance,  :type => Integer,   :default => 0
  
  index({ :account_id => 1, :sku => 1 })
  
  attr_reader :quantity, :cash, :credit, :subtotal_cash, :subtotal_credit, :total
  
  validates_inclusion_of    :complete,  :in => [true, false]
  validates_inclusion_of    :flagged,   :in => [true, false]
  validates_inclusion_of    :ratio,     :in => 0..1
  validates_presence_of     :sku
  validates_uniqueness_of   :sku, scope: :account_id
  validates_presence_of     :store, :till, :user
  
  default_scope ->{ where(:account_id => Account.current_id) }
  
  scope :search, ->(query) { query ? full_text_search(query) : all }
  scope :sorted, ->(sort, order) {
    if sort
      order ||= 'ASC'
      order_by("#{sort} #{order}")
    else
      desc(:updated_at)
    end
  }
  scope :user_id, ->(user_id) { where(:user_id => user_id) if user_id }
  scope :customer_id, ->(customer_id) { where(:customer_id => customer_id) if customer_id }
  scope :store_id, ->(store_id) { where(:store_id => store_id) if store_id }
  scope :till_id, ->(till_id) { where(:till_id => till_id) if till_id }
  
  belongs_to  :account
  belongs_to  :customer
  embeds_many :lines,   cascade_callbacks: true
  belongs_to  :store
  belongs_to  :till
  belongs_to  :user
  
  after_save :_complete
  
  accepts_nested_attributes_for :lines, :allow_destroy => true
  
  search_in :sku, :note, :lines => [:title, :sku, :note], :customer => [:first_name, :last_name, :sku], :till => [:name], :store => [:name], :user => [:username, :email, :first_name, :last_name]
  
  liquid_methods :account, :created_at, :complete, :completed_at, :credit_balance, :customer, :flagged, :note, :sku, :ratio, :quantity, :subtotal_cash, :subtotal_credit, :store, :till, :user, :cash, :credit, :due, :lines, :updated_at
  
  def self.trend(now, period_in_days)
    
    map = %Q{
      function() {
        var oneDay = 24*60*60*1000;
        var now = new Date();
        var date = new Date(this.completed_at);

        var days_ago = Math.round(Math.abs((now.getTime() - date.getTime())/(oneDay))) * -1;
        
        var quantity = 0;
        var subtotal_cash = 0;
        var subtotal_credit = 0;
        if (this.lines) {
          this.lines.forEach(function(line) {
            quantity += line.quantity;
            subtotal_cash += line.quantity * line.amount_cash;
            subtotal_credit += line.quantity * line.amount_credit;
          });
        }
        var cash = Math.round(subtotal_cash * (1 - this.ratio));
        var credit = Math.round(subtotal_credit * this.ratio);
        
        emit(days_ago, {count: 1, quantity: quantity, cash: cash, credit: credit});
      }
    }

    reduce = %Q{
      function(key, values) {
        var result = {count: 0, quantity: 0, cash: 0, credit: 0};
        values.forEach(function(value) {
          result.count += value.count;
          result.quantity += value.quantity;
          result.cash += value.cash;
          result.credit += value.credit;
        });
        return result;
      }
    }
    
    @purchases = Purchase.where(:complete => true, :completed_at.gte => now.beginning_of_day - period_in_days.to_i.days)
    @result = []
    
    unless @purchases.empty?
      @data = @purchases.map_reduce(map, reduce).out(inline: true)
      ((period_in_days.to_i * -1)..0).each do |day|
        @point = @data.find{|d| d['_id'] == day}
        if @point
          @result << { day: day, count: @point["value"]["count"], quantity: @point["value"]["quantity"], cash: @point["value"]["cash"], credit: @point["value"]["credit"] }
        else
          @result << { day: day, count: 0, quantity: 0, cash: 0, credit: 0}
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
  
  def subtotal_cash
    subtotal = 0
    lines.each do |line|
      subtotal += line.subtotal_cash
    end
    subtotal
  end
  
  def subtotal_credit
    subtotal = 0
    lines.each do |line|
      subtotal += line.subtotal_credit
    end
    subtotal
  end
  
  def cash
    (subtotal_cash * (1 - ratio)).round.to_i
  end
  
  def credit
    (subtotal_credit * ratio).round.to_i
  end
  
  def due
    cash
  end
  
  def completable?
    customer.present? && till.present? && user.present? && lines.count > 0 && due >= 0
  end
  
  protected
  
  def _complete
    if complete && completed_at.nil?
      if till && user
        title = "Purchase #{sku} #{Time.now.to_s} (#{user.fullname})"
        amount = cash * -1
        if amount < 0
          till.adjustments.create(:title => title, :amount => amount, :balance => till.balance, :user => user)
        end
      end
      if customer
        customer.add_credit(credit)
        set(:credit_balance, customer.credit)
      end
      set(:completed_at, Time.now.utc)
    end
    true
  end
end