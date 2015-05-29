class CreateDeposits < ActiveRecord::Migration
  def change
    create_table :deposits do |t|
      t.integer :amount
      t.integer :user_id
      t.datetime :settlement_date
      t.integer :charge_id
      t.timestamps null: false
    end
  end
end
