class AddCurrentDepositToUsers < ActiveRecord::Migration
  def change
    add_column :users, :current_deposit, :integer, :default => 0
  end
end
