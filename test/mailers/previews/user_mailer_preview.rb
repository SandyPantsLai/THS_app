# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview

  def activation_needed_email
    UserMailer.activation_needed_email
  end

  def activation_success_email
    UserMailer.activation_success_email
  end

  def hold_pickup_email_preview
    UserMailer.hold_pickup_email(Hold.where("pickup_expiry IS NOT NULL").first)
  end

  def overdue_email_preview
    date = 1.day.ago
    UserMailer.overdue_email( CheckOut.where( return_date: nil, due_date: ( date.beginning_of_day..date.end_of_day ) ).first )
  end
end
