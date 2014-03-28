class Job
  include ActiveAttr::Model
  
  attribute :name
  attribute :token
  attribute :handler
  
  validates_presence_of :name, :token, :handler

  def self.all
    jobs = []
    data = YAML.load_file "#{Rails.root}/config/jobs.yml"
    data['jobs'].each do |key, values|
      jobs << new(values)
    end
    jobs
  end
  
  def self.find(token)
    all.detect { |j| j.token == token } || nil
  end
end