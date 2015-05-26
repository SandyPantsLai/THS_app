class UserMailer < ApplicationMailer

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
       :subject => "Your THS Library Account is now Active")
  end

end
