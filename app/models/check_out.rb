class CheckOut < ActiveRecord::Base

  belongs_to :book_copy
  belongs_to :user
  has_one :fine

  CHECK_OUT_PERIOD = 7
  MAX_CHECK_OUT = 5
  RENEWAL_COUNT = 1

  MODE_RENEW = "renew"
  MODE_RETURN = "return"

   def get_fine_amount( return_date )
    days_due =  ( return_date.to_time.to_i - self.due_date.to_time.to_i ) / Fine::DAYS_IN_SECONDS
    days_due <= 0 ? 0 : ( days_due * Fine::DAILY_FINE_AMOUNT )
  end
end
