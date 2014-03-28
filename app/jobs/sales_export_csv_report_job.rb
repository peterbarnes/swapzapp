class SalesExportCSVReportJob < Struct.new(:account_id, :user_id, :report_id)
  def perform
    @account = Account.find(account_id)
    @account.set_current
    
    @user = User.find(user_id)
    
    @report = Report.find(report_id)
    
    Time.zone = @user.time_zone
    
    @from = Time.zone.local(@report.from.year, @report.from.month, @report.from.day)
    @to = Time.zone.local(@report.to.year, @report.to.month, @report.to.day)
    
    @sales = Sale.where(:complete => true, :completed_at.gte => @from, :completed_at.lte => @to)
    
    @file = Tempfile.new ["salesexportcsv", ".csv"], "#{Rails.root}/tmp"
    
    @csv = CSV.generate do |csv|
      csv << ["id","sku","completed_at","created_at","updated_at","note","tax_rate","quantity","subtotal","subtotal_taxable","subtotal_after_store_credit","subtotal_taxable_after_store_credit","tax","total","due"]
      
      @sales.each do |sale|
        csv << [sale.id, sale.sku, sale.completed_at, sale.created_at, sale.updated_at, sale.note, sale.tax_rate, sale.quantity, currency(sale.subtotal), currency(sale.subtotal_taxable), currency(sale.subtotal_after_store_credit), currency(sale.subtotal_taxable_after_store_credit), currency(sale.tax), currency(sale.total), currency(sale.due)]
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