class TimecardIndexSerializer < ActiveModel::Serializer
  delegate :params, to: :scope
  
  attributes :id, :user_id, :flagged, :in, :note, :out, :hours, :created_at, :updated_at
  
  has_one :user
  
  def include_associations!
    include! :user if params[:user]
  end
end