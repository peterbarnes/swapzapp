namespace :duplicate do

  desc "Duplicate inventories to given account"
  task :inventory, [:source_account, :destination_account, :inventory_id] => [:environment] do |t, args|
    source_account_name = args[:source_account]
    destination_account_name = args[:destination_account]
    inventory_id = args[:inventory_id]
    
    source_account = Account.where(:token => source_account_name).first
    destination_account = Account.where(:token => destination_account_name).first
    
    if source_account && destination_account
      inventory = source_account.inventories.unscoped.where(:id => inventory_id).first
      
      if inventory
        new_inventory = destination_account.inventories.new({
          :name => inventory.name, 
          :description => inventory.description, 
          :account => destination_account
        })
        new_inventory.save
        
        inventory.items.unscoped.each do |item|
          new_item = item.clone
          new_item.account = destination_account
          new_item.inventory = new_inventory
          new_item.save
          
          item.components.unscoped.each do |component|
            new_component = component.clone
            new_component.account = destination_account
            new_component.item = new_item
            new_component.save
          end
          item.conditions.unscoped.each do |condition|
            new_condition = condition.clone
            new_condition.account = destination_account
            new_condition.item = new_item
            new_condition.save
          end
          item.variants.unscoped.each do |variant|
            new_variant = variant.clone
            new_variant.account = destination_account
            new_variant.item = new_item
            new_variant.save
          end
        end
      end
    end
  end
end