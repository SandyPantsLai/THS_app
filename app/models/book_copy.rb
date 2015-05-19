class BookCopy < ActiveRecord::Base
  belongs_to :user through: :checkout
  has_many :books
end
