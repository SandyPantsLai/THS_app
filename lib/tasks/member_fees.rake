namespace :member_fees do
  desc "Update user to inactive if current month/year's fee is unpaid by the 5th of the month"

  task :deactivate_user => :environment do
    monthly_overdues = MemberFees.where(settlement_date == nil).where(amount == 1000)
    monthly_overdues.each do |m|
      m.user.update(status: "inactive")
    end
  end
end