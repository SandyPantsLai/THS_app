class AddLastNameToBook < ActiveRecord::Migration
  def change
    add_column :books, :last_name, :string
  end
end
