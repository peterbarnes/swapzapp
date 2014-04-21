# Sets up routing constraints for the API
# From http://railscasts.com/episodes/350-rest-api-versioning
class ApiConstraints
  def initialize(options)
    @version = options[:version]
    @default = options[:default]
  end

  def matches?(req)
    @default || req.headers['Accept'].include?("application/vnd.swapzapp.v#{@version}")
  end
end