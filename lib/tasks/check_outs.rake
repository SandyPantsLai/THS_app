namespace :check_outs do
  desc "Sends an email to users who have overdue books"

  task send_overdue_email: :environment do
    date = 1.day.ago
    due_check_outs = CheckOut.where( return_date: nil, due_date: ( date.beginning_of_day..date.end_of_day ) )

    due_check_outs.each do |check_out|
      UserMailer.overdue_email( check_out )
    end

    puts "Overdue book notices have been sent out for #{date.to_date}"
  end
end
