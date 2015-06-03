class AddQrColumnToBooks < ActiveRecord::Migration
  def change
  	add_column :books, :qr_code, :string
  end
end
