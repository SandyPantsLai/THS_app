namespace :holds do
  desc "Update hold queue by destroying expired holds and updating pick_up expiry for next hold in queue"

  task :update_hold_queue => :environment do
    holds = Hold.where("pickup_expiry IS NOT NULL").where("pickup_expiry <= ?", 1.day.ago.end_of_day)
    holds.each do |hold|
      next_hold = Hold.where(book_id: hold.book_id).where("pickup_expiry IS NULL").first
      next_hold.pickup_expiry = Time.now + 7.days
      hold.destroy
    end
  end

end
