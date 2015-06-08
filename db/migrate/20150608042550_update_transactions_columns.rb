class UpdateTransactionsColumns < ActiveRecord::Migration
  def change
    remove_column :member_fees, :charge_id, :string
    remove_column :deposits, :charge_id, :string
    add_column :member_fees, :notes, :string
    add_column :deposits, :notes, :string
  end
end
