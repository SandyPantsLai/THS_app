class CreateCheckOuts < ActiveRecord::Migration
  def change
    create_table :check_outs do |t|

      t.datetime "checkout_date"
      t.datetime "due_date"
      t.integer "user_id"
      t.integer "book_copy_id"
      t.integer "renewal"

      t.timestamps null: false
    end
  end
end
