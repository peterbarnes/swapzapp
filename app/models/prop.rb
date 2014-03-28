class Prop
  include Mongoid::Document
  
  field :key, :type => String
  field :value, :type => String
  
  validates_presence_of :key
  
  embedded_in :account
  embedded_in :item
  
  liquid_methods :key, :value
end