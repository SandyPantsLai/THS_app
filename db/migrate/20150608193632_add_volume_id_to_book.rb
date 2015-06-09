class AddVolumeIdToBook < ActiveRecord::Migration
  def change
    add_column :books, :volume_id, :integer
  end
end
