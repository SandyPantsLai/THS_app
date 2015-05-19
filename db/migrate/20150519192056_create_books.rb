class CreateBooks < ActiveRecord::Migration
  def change
    create_table :books do |t|
      t.string :author
      t.string :title
      t.string :subject
      t.datetime :published
      t.string :publisher
      t.integer :page_count
      t.integer :price
      t.text :description
      t.string :cover_image
      t.string :isbn

      t.timestamps null: false
    end
  end
end
