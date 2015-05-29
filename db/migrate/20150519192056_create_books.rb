class CreateBooks < ActiveRecord::Migration
  def change
    create_table :books do |t|
      t.string :title
      t.string :subtitle
      t.string :author
      t.string :publisher
      t.datetime :published_date
      t.text :description
      t.string :subject
      t.integer :page_count
      t.string :image
      t.string :type
      t.string :indetifier
      t.integer :book_copy_id
      t.integer :hold_id

      t.timestamps null: false
    end
  end
end
