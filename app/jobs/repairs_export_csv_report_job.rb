class RepairsExportCSVReportJob < Struct.new(:account_id, :user_id, :report_id)
  def perform
    @account = Account.find(account_id)
    @account.set_current
    
    @user = User.find(user_id)
    
    @report = Report.find(report_id)
    
    Time.zone = @user.time_zone
    
    @from = Time.zone.local(@report.from.year, @report.from.month, @report.from.day)
    @to = Time.zone.local(@report.to.year, @report.to.month, @report.to.day)
    
    @repairs = Repair.where(:complete => true, :completed_at.gte => @from, :completed_at.lte => @to)
    
    @file = Tempfile.new ["repairsexportcsv", ".csv"], "#{Rails.root}/tmp"
    
    @csv = CSV.generate do |csv|
      csv << ["id","sku","completed_at","created_at","updated_at","name","note","serial","symptoms","status","taxable","quantity","subtotal","total"]
      
      @repairs.each do |repair|
        csv << [repair.id, repair.sku, repair.completed_at, repair.created_at, repair.updated_at, repair.name, repair.note, repair.serial, repair.symptoms, repair.status, repair.taxable, repair.quantity, currency(repair.subtotal), currency(repair.total)]
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