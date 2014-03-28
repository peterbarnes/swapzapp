Mongoid::Search.setup do |config|
  config.match = :all
  config.allow_empty_search = true
end