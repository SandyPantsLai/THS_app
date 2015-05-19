class CheckOut < ActiveRecord::Base

  belongs_to :book_copy
  belongs_to :user
  has_one :fine

  RENEWAL_DATE = 3
  RENEWAL_PERIOD = 21

end
