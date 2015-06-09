namespace :deposits do
  desc "Create deposit transaction to be paid when deposit falls below $35"

  task :create_top_up_transaction => :environment do
    users = User.where(current_deposit: 0..35)
    users.each do |user|
      Transaction.top_up_deposit(user)
      user.update(status: "inactive")
    end
  end

end