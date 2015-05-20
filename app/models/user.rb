class User < ActiveRecord::Base
  authenticates_with_sorcery!

  validates :password, length: { minimum: 3 }
  validates :password, confirmation: true
  validates :password_confirmation, presence: true

  validates :email, uniqueness: true

  has_many :burrowed_books, through: :checkout, class_name: 'book_copy' 
	has_many :held_books, through: :checkout, class_name: 'book' 
	has_many :fines, through: :checkout 

end