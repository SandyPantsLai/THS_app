class CreateBookCopies < ActiveRecord::Migration
  def change
    create_table :book_copies do |t|
      t.integer :book_id
      t.integer :library_code
      t.string :condition
      t.string :format

      t.timestamps null: false
    end
  end
end
