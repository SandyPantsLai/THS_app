class CreateMemberFees < ActiveRecord::Migration
  def change
    create_table :member_fees do |t|
      t.integer :amount
      t.integer :user_id
      t.datetime :settlement_date

      t.timestamps null: false
    end
  end
end
