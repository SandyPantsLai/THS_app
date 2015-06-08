namespace :member_fees do
  desc "Update user to inactive if current month/year's fee is unpaid by the 5th of the month"

  task :deactivate_users => :environment do
    overdues = MemberFee.where(:settlement_date == nil)
    overdues.each do |overdue|
      overdue.user.update(status: "inactive")
    end
  end

end