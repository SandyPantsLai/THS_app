class RemoveSubjectFromBook < ActiveRecord::Migration
  def change
    remove_column :books, :subject
  end
end
