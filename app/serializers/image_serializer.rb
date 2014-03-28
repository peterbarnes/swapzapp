class ImageSerializer < ActiveModel::Serializer
  attributes :id, :name, :index, :description, :image_url
end