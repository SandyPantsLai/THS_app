class AddQrCodeToBookModel < ActiveRecord::Migration
  def change
    add_column :books, :qr_code_uid, :string
  end
end
