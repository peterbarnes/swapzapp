class ResetMailer < ActionMailer::Base
  default from: "from@example.com"

  def reset(user)
    @user = user
    mail to: user.email, :subject => 'Swapz Account Recovery', :template_path => 'mailers'
  end
end
