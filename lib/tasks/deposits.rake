namespace :deposits do
  desc "Create deposit transaction to be paid when deposit falls below $35"

  task :create_top_up_transaction => :environment do
    users = User.where(current_deposit: 0..35)
    users.each do |user|
      last_deposit = user.deposits.last
      unless last_deposit.settlement_date
        last_deposit.update(amount: 4000 - user.current_deposit, created_at: Time.now)
      else
        Deposit.create(amount: 4000 - user.current_deposit, user: user)
      end
    end
  end

end