# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview
  def hold_pickup_email_preview
    UserMailer.hold_pickup_email(Hold.where("pickup_expiry IS NOT NULL").first)
  end
end
