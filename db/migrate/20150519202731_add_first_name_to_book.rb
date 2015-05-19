class AddFirstNameToBook < ActiveRecord::Migration
  def change
    add_column :books, :first_name, :string
  end
end
