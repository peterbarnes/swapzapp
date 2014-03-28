class Account::AccountController < AdminController
  
  def edit
    @account = current_account
    @account_metadata = AccountMetadataSerializer.new(current_account, :root => 'account').to_json
  end
  
  def update
    @account = current_account
    
    if @account.update_attributes(params[:account])
      redirect_to edit_account_path, :notice => 'Account updated successfully!'
    else
      render :edit
    end
  end
  
  def regenerate
    current_account.regenerate_api_secret
    redirect_to edit_account_path, :notice => 'Account updated successfully!'
  end
end