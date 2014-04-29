class PurchasingJob < Struct.new(:account_id, :purchase_id)
  def perform
    @account = Account.find(account_id)
    @account.set_current
    
    @purchase = Purchase.where(:id => purchase_id).first
    
    if @purchase
      @purchase.lines.each do |line|
        @data = {
          :account_id => @account.id,
          :purchase_id => @purchase.id,
          :user_id => @purchase.user_id,
          :name => line.title,
          :sku => line.sku,
          :quantity => line.quantity,
          :cash_price => line.amount_cash,
          :credit_price => line.amount_credit,
          :ratio => @purchase.ratio
        }
        RestClient.post ENV['PURCHASING_URL'], @data.to_json, :content_type => :json, :accept => :json
      end
    end
  end
end