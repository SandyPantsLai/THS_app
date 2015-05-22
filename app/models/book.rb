class Book < ActiveRecord::Base
  has_many :book_copies
  has_many :holds
  belongs_to :subject
end
