class UserMailer < ApplicationMailer
  default from: 'god@ths.com'

  def hold_pickup_email(hold)
    @user = User.find(hold.user_id)
    @hold = hold
    mail(to: @user.email, subject: 'You have a hold available for pickup')
  end
end
