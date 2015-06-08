class RemoveSubjectIdQrCode < ActiveRecord::Migration
  def change
  	remove_column :books, :subject_id, :integer
  	remove_column :books, :qr_code_uid, :string
  end
end
