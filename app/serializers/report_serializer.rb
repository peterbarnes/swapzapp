class ReportSerializer < ActiveModel::Serializer
  attributes :id, :complete, :file_url, :from, :name, :to, :job, :created_at, :updated_at
  
  def file_url
    object.file.url if object.file
  end
end