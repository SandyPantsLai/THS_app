class CreateFines < ActiveRecord::Migration
  def change
    create_table :fines do |t|
      t.integer :amount
      t.datetime :settlement_date
      t.integer :check_out_id
      t.timestamps null: false
    end
  end
end
