class ChangeBookColumnNames < ActiveRecord::Migration
  def change
  	rename_column :books, :authors, :author
  	rename_column :books, :categories, :category  
  end
end
