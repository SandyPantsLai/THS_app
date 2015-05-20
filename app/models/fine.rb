class Fine < ActiveRecord::Base

=begin
  Might need to implement a callback that retrieves the CheckOut object associated
  with this Fine, in order to perform operations such as computing the fine amount
=end

  helper_method : compute_fine

  DAILY_FINE_AMOUNT = 20
  DAYS_IN_SECONDS = 86400


  private
  def compute_fine
    check_out = CheckOut.find( check_out_id )
    days_due =  ( check_out.return_date.to_time.to_i - check_out.due_date.to_time.to_i ) / DAYS_IN_SECONDS

    days_due <= 0 ? 0 : ( days_due * DAILY_FINE_AMOUNT ) / 100.0
  end

end
