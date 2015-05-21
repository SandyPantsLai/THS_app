class CheckOut < ActiveRecord::Base

  belongs_to :book_copy
  belongs_to :user
  has_one :fine

  CHECK_OUT_PERIOD = 7
  RENEWAL_COUNT = 1

  MODE_RENEW = "renew"
  MODE_RETURN = "return"

end
