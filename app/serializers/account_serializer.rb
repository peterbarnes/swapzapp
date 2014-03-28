class AccountSerializer < ActiveModel::Serializer
  attributes :id, :api_active, :api_secret, :namespace, :title, :token, :created_at, :updated_at
end