class RemoveColumns < ActiveRecord::Migration
  def change
  	remove_column :book, :publisher
end
