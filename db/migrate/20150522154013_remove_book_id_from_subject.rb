class RemoveBookIdFromSubject < ActiveRecord::Migration
  def change
    remove_column :subjects, :book_id
  end
end
