class ComponentSerializer < ActiveModel::Serializer
  attributes :id, :item_id, :adjustment, :adjustment_percentage, :adjustment_cash, :adjustment_cash_percentage, :adjustment_credit, :adjustment_credit_percentage, :description, :name, :typical
end