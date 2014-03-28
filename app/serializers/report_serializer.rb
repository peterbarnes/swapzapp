class ReportSerializer < ActiveModel::Serializer
  attributes :id, :complete, :file_url, :from, :title, :to, :type, :created_at, :updated_at
  
  def file_url
    object.file.url if object.file
  end
end