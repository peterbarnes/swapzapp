class AccountMetadataSerializer < ActiveModel::Serializer
  attributes :api, :title, :token
  
  def ip
    Socket.ip_address_list.find {|a| !a.ipv4_loopback? && !(a.ipv6_sitelocal? || a.ipv6_linklocal? || a.ipv6_loopback?) }.ip_address
  end
  
  def api
    {
      :url => Rails.env.production? ? "http://#{object.token}.swapzapp.com/api" : "http://#{object.token}.#{ip}.xip.io/api",
      :key => 'x',
      :secret => object.api_secret,
      :active => object.api_active
    }
  end
end