class AddressSerializer < ActiveModel::Serializer
  attributes :id, :name, :city, :country, :first_line, :second_line, :state, :zip
end