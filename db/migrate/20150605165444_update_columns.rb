class UpdateColumns < ActiveRecord::Migration
  def change
    change_column :member_fees, :charge_id,  :string
    change_column :deposits, :charge_id,  :string
  end
end
