class AddReturnDateToCheckOut < ActiveRecord::Migration
  def change
    add_column 'check_outs', :return_date, :datetime
  end
end
