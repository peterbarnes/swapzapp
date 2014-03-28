class TillMetadataSerializer < ActiveModel::Serializer
  attributes :id, :socket, :name
  
  def ip
    Socket.ip_address_list.find {|a| !a.ipv4_loopback? && !(a.ipv6_sitelocal? || a.ipv6_linklocal? || a.ipv6_loopback?) }.ip_address
  end
  
  def socket
    {
      :url => Rails.env.production? ? ENV['SOCKET_URL'] : "http://#{ip}",
      :port => Rails.env.production? ? 80 : 3000,
      :namespace => object.account.namespace
    }
  end
end