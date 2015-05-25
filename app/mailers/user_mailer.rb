class UserMailer < ApplicationMailer
  helper :application
  default from: "Toronto Hermetic Society Library Services <god@ths.com>",
          return_path: 'god@ths.com',
          sender: 'god@ths.com'

  def hold_pickup_email(hold)
    @user = User.find(hold.user_id)
    @hold = hold
    mail(to: @user.email, subject: 'You have a hold available for pickup')
  end
end
