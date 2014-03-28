class PhoneSerializer < ActiveModel::Serializer
  attributes :id, :name, :number
end