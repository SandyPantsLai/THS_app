class Book < ActiveRecord::Base
  has_many :book_copies
  has_many :holds
end
