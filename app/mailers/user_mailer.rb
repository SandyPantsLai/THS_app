class UserMailer < ActionMailer::Base
  
  default :from => "no-reply@thslibrary.com" # need to change this 
  
  # user activation email
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
  
  # user reset password email
  def reset_password_email(user)
    @user = user
    @url  = "http://0.0.0.0:3000/password_resets/#{user.reset_password_token}/edit"
    mail(:to => user.email,
         :subject => "Reset Your THS Library Password")
  end

  helper :application
  default from: "Toronto Hermetic Society Library Services <god@ths.com>",
          return_path: 'god@ths.com',
          sender: 'god@ths.com'

  # user hold ready email
  def hold_pickup_email(hold)
    @user = User.find(hold.user_id)
    @hold = hold
    @title = Book.find(@hold.book_id).title
    mail(to: @user.email, subject: 'Your hold is available for pickup')
  end

  #user overdue warning email
  def overdue_email( check_out )
    @user = checkout.user
    @check_out = check_out
    @book = checkout.book_copy.book
    mail( to: @user.email, subject: "#{@book.title} is now overdue" )
  end

end
