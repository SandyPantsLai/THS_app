class UserMailer < ApplicationMailer
  helper :application
  default from: "Toronto Hermetic Society Library Services <god@ths.com>",
          return_path: 'god@ths.com',
          sender: 'god@ths.com'

  def hold_pickup_email(hold)
    @user = User.find(hold.user_id)
    @hold = hold
    @title = Book.find(@hold.book_id).title
    mail(to: @user.email, subject: 'Your hold is available for pickup')
  end
end
