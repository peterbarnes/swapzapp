class PurchasesExportCSVReportJob < Struct.new(:account_id, :user_id, :report_id)
  def perform
    @account = Account.find(account_id)
    @account.set_current
    
    @user = User.find(user_id)
    
    @report = Report.find(report_id)
    
    Time.zone = @user.time_zone
    
    @from = Time.zone.local(@report.from.year, @report.from.month, @report.from.day)
    @to = Time.zone.local(@report.to.year, @report.to.month, @report.to.day)
    
    @purchases = Purchase.where(:complete => true, :completed_at.gte => @from, :completed_at.lte => @to)
    
    @file = Tempfile.new ["purchasesexportcsv", ".csv"], "#{Rails.root}/tmp"
    
    @csv = CSV.generate do |csv|
      csv << ["id","sku","completed_at","created_at","updated_at","note","ratio","quantity","subtotal_cash","subtotal_credit","cash","credit","due"]
      
      @purchases.each do |purchase|
        csv << [purchase.id, purchase.sku, purchase.completed_at, purchase.created_at, purchase.updated_at, purchase.note, purchase.ratio, purchase.quantity, currency(purchase.subtotal_cash), currency(purchase.subtotal_credit), currency(purchase.cash), currency(purchase.credit), currency(purchase.due)]
      end
    end
    
    @file.write @csv
    @file.rewind
    
    @report.complete = true
    @report.file = @file
    @report.save
    
    @file.close
    @file.unlink
  end
  
  def currency(pennies)
    pennies.to_f / 100
  end
end