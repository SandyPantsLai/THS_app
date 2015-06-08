class ChangeBookVolumeIdType < ActiveRecord::Migration
  def change
    change_column :books, :volume_id, :string
  end
end
