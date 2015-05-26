class UserMailer < ActionMailer::Base
  
  default :from => "no-reply@thslibrary.com" # need to change this 
  
  def activation_needed_email(user)
    @user = user
    @url  = "http://0.0.0.0:3000/users/#{user.activation_token}/activate"
    mail(:to => user.email,
         :subject => "Welcome to the THS Library")
  end
  
  def activation_success_email(user)
    @user = user
    @url  = "http://0.0.0.0:3000/login"
    mail(:to => user.email,
         :subject => "Your THS Library Account is now Activated")
  end
  
  def reset_password_email(user)
    @user = user
    @url  = "http://0.0.0.0:3000/password_resets/#{user.reset_password_token}/edit"
    mail(:to => user.email,
         :subject => "Reset Your THS Library Password")
  end
end
