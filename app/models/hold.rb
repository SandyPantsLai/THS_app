class Hold < ActiveRecord::Base
  belongs_to :user through: :held_book, class_name: "Book"
  belongs_to :book
end
