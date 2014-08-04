class Phone
  include Mongoid::Document
  
  field :number, :type => String
  field :name, :type => String
  
  embedded_in :customer
  embedded_in :store
  
  liquid_methods :number, :name, :formatted
  
  def formatted
    if number.length == 7
      number.insert(3,'-')
    elsif number.length == 10
      number.insert(3,'-').insert(7,'-')
    elsif number.length == 11
      number.insert(1,'-').insert(5,'-').insert(9,'-')
    else
      number
    end
  end
end