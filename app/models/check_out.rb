class CheckOut < ActiveRecord::Base
  belongs_to :book_copy
  belongs_to :user
  has_one :fine
end
