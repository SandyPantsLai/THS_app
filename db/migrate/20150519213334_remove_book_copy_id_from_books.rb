class RemoveBookCopyIdFromBooks < ActiveRecord::Migration
  def change
    remove_column :books, :book_copy_id, :integer
    change_column :books, :published, :integer
  end
end
