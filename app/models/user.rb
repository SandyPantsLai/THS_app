class User < ActiveRecord::Base
  authenticates_with_sorcery!

  validates :password, length: { minimum: 3 }, :if => :password
  validates :password, confirmation: true, :if => :password

  validates :email, uniqueness: true

  has_many :burrowed_books, through: :checkout, class_name: 'book_copy'
	has_many :held_books, through: :checkout, class_name: 'book'
	has_many :fines, through: :checkout
  has_many :member_fees

end