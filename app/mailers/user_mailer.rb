class UserMailer < ApplicationMailer
  default from: "library@thslibrary.com"
  layout 'mailer'

  def welcome_email(user)
    @user = user
    @url  = 'http://example.com/login'
    mail(to: @user.email, subject: 'Welcome to My Awesome Site')
  end

  def late_email(user)
    @user = user
    @url = 'blahblahblah'
    mail(to: @user.email, subject: 'Late Book Return')
  end
end
