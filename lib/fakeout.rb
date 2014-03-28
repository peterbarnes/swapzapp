class Fakeout

  MODELS = %w(User Customer Certificate Store Location Till Inventory Item Unit Purchase Repair Sale Timecard)
  
  def build_account
    {
      :title                => 'Example',
      :token                => 'example',
      :api_active           => true
    }
  end
  
  def build_address
    {
      :name         => ['Home', 'Shipping', 'Business'].sample,
      :city         => Faker::Address.city,
      :country      => Faker::Address.country_code('United States'),
      :first_line   => Faker::Address.street_address,
      :second_line  => Faker::Address.secondary_address,
      :state        => Faker::AddressUS.state_abbr,
      :zip          => Faker::AddressUS.zip_code
    }
  end
  
  def build_adjustment(amount = rand(1..10000) * [-1, 1].sample, balance = 0, title = Faker::Lorem.sentence, user = nil)
    {
      :amount         => amount,
      :balance        => balance,
      :description    => Faker::Lorem.sentence,
      :title          => title,
      :user           => user
    }
  end
  
  def build_certificate
    amount = rand(1..10000)
    {
      :active         => [true, false].sample,
      :amount         => amount,
      :balance        => (amount * (rand(1..100) * 0.01)).to_i,
      :customer       => pick_random(Customer, true)
    }
  end
  
  def build_component(base_price_in_pennies)
    base_price = base_price_in_pennies * 0.01
    percentage = [true, false].sample
    if percentage
      {
        :adjustment => rand(1..100) * 0.01,
        :adjustment_percentage => percentage,
        :adjustment_cash => rand(1..100) * 0.01,
        :adjustment_cash_percentage => percentage,
        :adjustment_credit => rand(1..100) * 0.01,
        :adjustment_credit_percentage => percentage,
        :description => Faker::Lorem.sentence,
        :name => Faker::Product.product_name,
        :typical => [true, false].sample,
        :account => @account
      }
    else
      {
        :adjustment => (base_price * (rand(1..100) * 0.01)),
        :adjustment_percentage => percentage,
        :adjustment_cash => (base_price * (rand(1..100) * 0.01)),
        :adjustment_cash_percentage => percentage,
        :adjustment_credit => (base_price * (rand(1..100) * 0.01)),
        :adjustment_credit_percentage => percentage,
        :description => Faker::Lorem.sentence,
        :name => Faker::Product.product_name,
        :typical => [true, false].sample,
        :account => @account
      }
    end
  end
  
  def build_condition(base_price_in_pennies)
    base_price = base_price_in_pennies * 0.01
    percentage = [true, false].sample
    multiplier = [-1, 1].sample
    names = ['New', 'Used', 'Very Good', 'Good', 'Acceptable', 'Parts']
    if percentage
      {
        :adjustment => rand(1..100) * 0.01 * multiplier,
        :adjustment_percentage => percentage,
        :adjustment_cash => rand(1..100) * 0.01 * multiplier,
        :adjustment_cash_percentage => percentage,
        :adjustment_credit => rand(1..100) * 0.01 * multiplier,
        :adjustment_credit_percentage => percentage,
        :description => Faker::Lorem.sentence,
        :name => names.sample,
        :account => @account
      }
    else
      {
        :adjustment => (base_price * (rand(1..100) * 0.01)) * multiplier,
        :adjustment_percentage => percentage,
        :adjustment_cash => (base_price * (rand(1..100) * 0.01)) * multiplier,
        :adjustment_cash_percentage => percentage,
        :adjustment_credit => (base_price * (rand(1..100) * 0.01)) * multiplier,
        :adjustment_credit_percentage => percentage,
        :description => Faker::Lorem.sentence,
        :name => names.sample,
        :account => @account
      }
    end
  end
  
  def build_customer
    addresses = []
    phones = []
    images = []
    rand(1..5).times do
      addresses << Address.new(build_address)
      phones << Phone.new(build_phone)
      images << build_image(URI.parse('http://placekitten.com/g/200/200/'))
    end
    {
      :credit             => rand(1..10000),
      :date_of_birth      => fake_time_from(20.years.ago),
      :email              => Faker::Internet.email,
      :first_name         => Faker::Name.first_name,
      :identifier         => Faker::Identification.drivers_license,
      :identifier_type    => Faker::AddressUS.state_abbr,
      :last_name          => Faker::Name.last_name,
      :notes              => Faker::Lorem.sentence,
      :organization       => Faker::Company.name,
      :addresses          => addresses,
      :phones             => phones,
      :images_attributes  => images
    }
  end
  
  def build_image(image)
    {
      :description  => Faker::Lorem.sentence,
      :name         => Faker::Product.brand,
      :image        => image
    }
  end
  
  def build_inventory
    {
      :description  => Faker::Lorem.sentence,
      :name         => Faker::Product.brand
    }
  end
  
  def build_item
    base_price = rand(1..10000)
    components = []
    conditions = []
    variants = []
    tags = []
    props = []
    images = []
    rand(1..5).times do
      components << build_component(base_price)
      conditions << build_condition(base_price)
      variants << build_variant(base_price)
      tags << Tag.new(build_tag)
      props << Prop.new(build_prop)
      images << build_image(URI.parse('http://placekitten.com/g/200/200/'))
    end
    {
      :depth                    => rand * 100,
      :description              => Faker::Lorem.sentence,
      :dimension_measure        => Faker::UnitEnglish.length_abbr,
      :flagged                  => [true, false].sample,
      :height                   => rand * 100,
      :identifier               => rand(100000000..999999999),
      :identifier_type          => ['UPC-A', 'UPC-E', 'EAN-8', 'EAN-13', 'ISBN'].sample,
      :manufacturer             => Faker::Product.brand,
      :name                     => Faker::Product.product,
      :price                    => base_price,
      :price_cash               => (base_price * rand).to_i,
      :price_credit             => (base_price * rand).to_i,
      :saleable                 => [true, false].sample,
      :taxable                  => [true, false].sample,
      :weight                   => rand * 100,
      :weight_measure           => Faker::UnitEnglish.mass_abbr,
      :width                    => rand * 100,
      :components_attributes    => components,
      :conditions_attributes    => conditions,
      :images_attributes        => images,
      :inventory                => pick_random(Inventory),
      :props                    => props,
      :tags                     => tags,
      :variants_attributes      => variants
    }
  end
  
  def build_line
    amount = rand(1..10000)
    amount_purchase = (amount * rand).to_i
    bullets = []
    rand(1..5).times do
      bullets << Faker::Product.product_name
    end
    {
      :amount         => amount,
      :amount_cash    => (amount_purchase * rand).to_i * -1,
      :amount_credit  => amount_purchase * -1,
      :bullets        => bullets,
      :note           => Faker::Lorem.sentence,
      :quantity       => rand(10),
      :sku            => SecureRandom.hex(8).upcase,
      :taxable        => [true, false].sample,
      :title          => Faker::Product.product,
      :certificate    => pick_random(Certificate, true),
      :item           => pick_random(Item, true),
      :unit           => pick_random(Unit, true)
    }
  end
  
  def build_location
    {
      :description      => Faker::Lorem.sentence,
      :name             => Faker::Venue.name,
      :restock          => rand(100),
      :target           => rand(100),
      :store            => pick_random(Store),
      :image_attributes => build_image(URI.parse('http://placekitten.com/g/200/200/'))
    }
  end
  
  def build_log
    {
      :name => ['On Hold', 'Finished', 'Ordered Parts', 'In Shop', 'Received', 'Paid'].sample,
      :note => Faker::Lorem.sentence,
      :user => pick_random(User)
    }
  end
  
  def build_payment
    {
      :cash => rand(1..10000),
      :credit => rand(1..10000),
      :check => rand(1..10000),
      :gift_card => rand(1..10000),
      :store_credit => rand(1..10000)
    }
  end
  
  def build_phone
    names = ['Home', 'Cell', 'Work']
    {
      :number   => Faker::PhoneNumber.short_phone_number.gsub('-', '').gsub('(','').gsub(')', ''),
      :name     => names.sample
    }
  end
  
  def build_prop
    {
      :key    => Faker::HipsterIpsum.word.titleize,
      :value  => Faker::HipsterIpsum.word
    }
  end
  
  def build_purchase
    till = pick_random(Till)
    lines = []
    rand(5).times do 
      lines << Line.new(build_line())
    end
    {
      :flagged    => [true, false].sample,
      :note       => Faker::Lorem.sentence,
      :ratio      => rand,
      :customer   => pick_random(Customer, true),
      :lines      => lines,
      :store      => till.store,
      :till       => till,
      :user       => pick_random(User)
    }
  end
  
  def build_repair
    till = pick_random(Till)
    lines = []
    logs = []
    images = []
    rand(5).times do
      lines << Line.new(build_line())
      logs << Log.new(build_log())
      images << build_image(URI.parse('http://placekitten.com/g/200/200/'))
    end
    {
      :flagged          => [true, false].sample,
      :note             => Faker::Lorem.sentence,
      :identifier       => rand(100000000..999999999),
      :identifier_type  => 'Serial',
      :symptoms         => Faker::Lorem.paragraph,
      :tax_rate         => till.tax_rate,
      :customer         => pick_random(Customer),
      :lines            => lines,
      :location         => pick_random(Location),
      :logs             => logs,
      :payment          => Payment.new(build_payment()),
      :store            => pick_random(Store),
      :till             => till,
      :user             => pick_random(User),
      :images           => images
    }
  end
  
  def build_sale
    till = pick_random(Till)
    lines = []
    rand(5).times do 
      lines << Line.new(build_line())
    end
    {
      :flagged      => [true, false].sample,
      :note         => Faker::Lorem.sentence,
      :tax_rate     => till.tax_rate,
      :certificate  => pick_random(Certificate, true),
      :customer     => pick_random(Customer, true),
      :lines        => lines,
      :payment      => Payment.new(build_payment()),
      :store        => till.store,
      :till         => till,
      :user         => pick_random(User)
    }
  end
  
  def build_store
    phones = []
    rand(1..5).times do
      phones << Phone.new(build_phone)
    end
    {
      :description      => Faker::Lorem.sentence,
      :legal            => Faker::Lorem.paragraph,
      :name             => Faker::Company.name,
      :address          => Address.new(build_address),
      :phones           => phones,
      :image_attributes => build_image(URI.parse('http://placekitten.com/g/200/200/'))
    }
  end
  
  def build_tag
    {
      :name => Faker::HipsterIpsum.word.titleize
    }
  end
  
  def build_till
    {
      :balance => 0,
      :minimum => 0,
      :name => "Till #{SecureRandom.hex(2).upcase}",
      :tax_rate => (rand * 0.1).round(2),
      :adjustments => [Adjustment.new(build_adjustment(0, 0, 'Initial Adjustment', pick_random(User)))],
      :store => pick_random(Store),
      :user => pick_random(User, true)
    }
  end
  
  def build_timecard
    {
      :flagged      => [true, false].sample,
      :in           => fake_time_from(2.weeks.ago) - 1.week,
      :note         => Faker::Lorem.sentence,
      :out          => fake_time_from(1.week.ago),
      :user         => pick_random(User)
    }
  end
  
  def build_unit
    item = pick_random(Item)
    {
      :price => rand(1..10000),
      :quantity => rand(100),
      :calculated => [true, false].sample,
      :item => item,
      :location => pick_random(Location),
      :components => [item.components.sample],
      :conditions => [item.conditions.sample],
      :variant => item.variants.sample
    }
  end
  
  def build_user(username = "#{Faker::Internet.user_name}_#{random_letters}", email = Faker::Internet.email, password = 'password', pin = '0000', administrator = false)
    { 
      :username              => username,
      :email                 => email,
      :password              => password,
      :password_confirmation => password,
      :first_name            => Faker::Name.first_name,
      :last_name             => Faker::Name.last_name,
      :administrator         => administrator,
      :pin                   => pin
    }
  end
  
  def build_variant(base_price_in_pennies)
    base_price = base_price_in_pennies * 0.01
    percentage = [true, false].sample
    multiplier = [-1, 1].sample
    if percentage
      {
        :adjustment => rand(1..100) * 0.01 * multiplier,
        :adjustment_percentage => percentage,
        :adjustment_cash => rand(1..100) * 0.01 * multiplier,
        :adjustment_cash_percentage => percentage,
        :adjustment_credit => rand(1..100) * 0.01 * multiplier,
        :adjustment_credit_percentage => percentage,
        :description => Faker::Lorem.sentence,
        :name => Faker::Product.model,
        :account => @account
      }
    else
      {
        :adjustment => (base_price * (rand(1..100) * 0.01)) * multiplier,
        :adjustment_percentage => percentage,
        :adjustment_cash => (base_price * (rand(1..100) * 0.01)) * multiplier,
        :adjustment_cash_percentage => percentage,
        :adjustment_credit => (base_price * (rand(1..100) * 0.01)) * multiplier,
        :adjustment_credit_percentage => percentage,
        :description => Faker::Lorem.sentence,
        :name => Faker::Product.model,
        :account => @account
      }
    end
  end
  
  def post_fake
    rand(1..@account.purchases.count).times do
      purchase = pick_random(Purchase)
      purchase.update_attribute(:complete, true)
      purchase.update_attribute(:completed_at, fake_time_from(1.week.ago))
    end
    rand(1..@account.sales.count).times do
      sale = pick_random(Sale)
      sale.update_attribute(:complete, true)
      sale.update_attribute(:completed_at, fake_time_from(1.week.ago))
    end
    rand(1..@account.repairs.count).times do
      repair = pick_random(Repair)
      repair.update_attribute(:complete, true)
      repair.update_attribute(:completed_at, fake_time_from(1.week.ago))
    end
  end

  def tiny
    1
  end
  
  def small
    25+rand(50)
  end

  def medium
    250+rand(250)
  end

  def large
    1000+rand(500)
  end

  attr_accessor :size

  def initialize(size, prompt=true)
    self.size = size
  end

  def fakeout
    puts "Faking it ... (#{size})"
    @account = Account.create!(build_account)
    @account.set_current
    @account.users.create!(build_user('example', 'example@example.com', 'password', '0000', true))
    MODELS.each do |model|
      if !respond_to?("build_#{model.downcase}")
        puts "  * #{model.pluralize}: **warning** I couldn't find a build_#{model.downcase} method"
        next
      end
      1.upto(send(size)) do
        attributes = send("build_#{model.downcase}")
        @account.send(model.downcase.pluralize).create!(attributes) if attributes && !attributes.empty?
      end
      puts "  * #{model.pluralize}: #{model.constantize.count}"
    end
    post_fake
    puts "Done, I Faked it!"
  end
  
  def self.prompt
    puts "Are you sure? This will delete the example account data from your #{Rails.env} database y/n? "
    STDOUT.flush
    (STDIN.gets =~ /^y|^Y/) ? true : exit(0)
  end

  def self.clean(prompt = true)
    self.prompt if prompt
    puts "Cleaning all ..."
    Account.where(:token => 'example').destroy_all
  end
  
  private
  def pick_random(model, optional = false)
    return nil if optional && (rand(2) > 0)
    ids = model.only(:_id).map(&:_id)
    model.find(ids.sample) unless ids.blank?
  end

  def random_letters(length = 2)
    Array.new(length) { (rand(122-97) + 97).chr }.join
  end

  def fake_time_from(time_ago = 1.year.ago)
    time_ago+(rand(((Time.now - time_ago) / (60*60)).round)).hours
  end
end