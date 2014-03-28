class Address
  include Mongoid::Document
  
  field :name, :type => String
  field :city, :type => String
  field :country, :type => String, :default => 'US'
  field :first_line, :type => String
  field :second_line, :type => String
  field :state, :type => String
  field :zip, :type => String
  
  embedded_in :customer
  embedded_in :store
  
  liquid_methods :name, :city, :country, :first_line, :second_line, :state, :zip
end