class TemplateSerializer < ActiveModel::Serializer
  attributes :id, :name, :category, :body, :primary
end