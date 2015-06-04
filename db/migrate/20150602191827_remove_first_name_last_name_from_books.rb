class RemoveFirstNameLastNameFromBooks < ActiveRecord::Migration
  def change
  	remove_column :books, :first_name, :string
  	remove_column :books, :last_name, :string
  end
end
