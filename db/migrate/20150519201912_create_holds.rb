class CreateHolds < ActiveRecord::Migration
  def change
    create_table :holds do |t|
      t.integer :user_id
      t.integer :book_id
      t.datetime :pickup_expiry

      t.timestamps null: false
    end
  end
end
