class Image
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paperclip
  include Mongoid::Search
  
  field :name,            :type => String, :default => 'Untitled'
  field :description,     :type => String
  field :index,           :type => Integer, :default => 0
  
  validates_presence_of   :name, :index
  
  attr_accessor :image_url, :image_delete
  attr_writer :image_data
  
  before_validation { image.clear if image_delete == '1' }
  
  has_mongoid_attached_file :image,
    :default_url => '/assets/missing.png',
    :styles => {
      :tiny       => ['16x16#',   :png],
      :small      => ['48x48#',   :png],
      :medium     => ['128x128#',   :png],
      :large      => ['256x256#',   :png]
    }
  
  embedded_in     :customer
  embedded_in     :item
  embedded_in     :location
  embedded_in     :repair
  embedded_in     :store
  
  search_in  :name, :description
  
  liquid_methods :created_at, :name, :description, :updated_at, :image_url, :image_data
  
  def image_url=(url)
    unless url.to_s.empty?
      self.image = URI.parse(url)
    end
  end
  
  def image_url
    self.image.url
  end
  
  def image_data=(data)
    StringIO.open(Base64.decode64(data.split(',').pop)) do |string|
      string.class.class_eval { attr_accessor :original_filename, :content_type }
      string.original_filename = "#{DateTime.now.to_i}.png"
      string.content_type = "image/png"
      self.image = string
    end
  end
  
  def method_missing(*args)
    self.image.send(*args)
  end
end