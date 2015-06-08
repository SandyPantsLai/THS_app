class UpdateTransactionsColumns < ActiveRecord::Migration
  def change
    add_column :member_fees, :notes, :string
    add_column :deposits, :notes, :string
  end
end
