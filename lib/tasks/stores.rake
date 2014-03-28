namespace :store do

  desc "Fix store data for sales"
  task :fix => :environment do |t, args|
    a = Account.last
    a.set_current
    
    a.stores.each do |store|
      store_id = store.id
      till_ids = store.tills.only(:id).all.map(&:id)
      Sale.all.each {|s| s.set(:store_id, store_id) if till_ids.include?(s.till_id) }
      Purchase.all.each {|p| p.set(:store_id, store_id) if till_ids.include?(p.till_id) }
    end
  end
end