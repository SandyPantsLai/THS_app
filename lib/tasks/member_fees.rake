namespace :member_fees do
  desc "Update user to inactive if current month/year's fee is unpaid by the 5th of the month"

  task :deactivate_users => :environment do
    overdues = MemberFee.where(:settlement_date == nil)
    overdues.each do |overdue|
      overdue.user.update(status: "inactive")
    end
  end

  desc "Create monthly membership fee and delete previous unpaid fees"

  task :create_monthly_fee => :environment do
    users = User.where(:membership == "monthly")
    users.each do |user|
      last_fee = user.member_fees.last
      last_fee.destroy if last_fee.settlement_date == nil
      Transaction.create_member_fee(user)
    end
  end

  desc "Create annual membership fee and delete previous unpaid fees"

  task :create_annual_fee => :environment do
    users = User.where(:membership == "annual")
    users.each do |user|
      last_fee = user.member_fees.last
      #only creates fee if the last annual payment was the same month as now
      if last_fee.created_at.month == Time.now.month
        last_fee.destroy if last_fee.settlement_date == nil
        Transaction.create_member_fee(user)
      end
    end
  end

end