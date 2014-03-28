class TimecardsExportCSVReportJob < Struct.new(:account_id, :user_id, :report_id)
  def perform
    @account = Account.find(account_id)
    @account.set_current
    
    @user = User.find(user_id)
    
    @report = Report.find(report_id)
    
    Time.zone = @user.time_zone
    
    @from = Time.zone.local(@report.from.year, @report.from.month, @report.from.day)
    @to = Time.zone.local(@report.to.year, @report.to.month, @report.to.day)
    
    @timecards = Timecard.where(:created_at.gte => @from, :created_at.lte => @to, :out.ne => nil, :out.exists => true).asc(:user_id)
    
    @file = Tempfile.new ["timecardsexportcsv", ".csv"], "#{Rails.root}/tmp"
    
    @csv = CSV.generate do |csv|
      csv << ["id","created_at","updated_at","user","in","out","hours","note"]
      
      @timecards.each do |timecard|
        csv << [timecard.id, timecard.created_at, timecard.updated_at, timecard.user.fullname, timecard.in, timecard.out, timecard.hours, timecard.note]
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