namespace :holds do
  #current cron has this set to be run daily at midnight
  desc "Update hold queue by destroying expired holds and updating pick_up expiry for next hold in queue"

  task :update_hold_queue => :environment do
    holds = Hold.where("pickup_expiry IS NOT NULL").where("pickup_expiry <= ?", 1.day.ago.end_of_day)
    holds.each do |hold|
      next_hold = Hold.where(book_id: hold.book_id).where("pickup_expiry IS NULL").first
      next_hold.update(pickup_expiry: Time.now + 7.days) if next_hold
      hold.destroy
    end
  end

  desc "Sends an email to users who have holds available for pickup"

  task :send_hold_pickup_email => :environment do

    date = 7.days.from_now

    new_hold_pickups = Hold.where( pickup_expiry: ( date.beginning_of_day..date.end_of_day ) )

    new_hold_pickups.each do |hold|
      UserMailer.hold_pickup_email(hold)
    end

    puts "Hold pickup notices have been sent out for holds expiring on #{date.to_date}"
  end
end
