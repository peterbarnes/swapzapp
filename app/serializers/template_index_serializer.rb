class TemplateIndexSerializer < ActiveModel::Serializer
  attributes :id, :name, :category, :body, :primary
end