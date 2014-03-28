class Tag
  include Mongoid::Document
  
  field :name, :type => String
  
  validates_presence_of :name
  
  embedded_in :item
  
  liquid_methods :name
end