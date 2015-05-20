# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.create!(
    first_name: "Johnny",
    last_name: "Adminseed",
    email: "god@ths.com",
    password: '1234',
    password_confirmation: '1234',
    role: 'admin'
)

User.create!(
    first_name: "Mere",
    last_name: "Thing",
    email: "minion@@ths.com",
    password: '4321',
    password_confirmation: '4321',
    role: 'user'
)

10.times do
	User.create!(first_name: Faker::Name.first_name, last_name: Faker::Name.last_name, email: Faker::Internet.email, phone_number: Faker::PhoneNumber.phone_number, password: '4321', password_confirmation: '4321', role: 'user')
end

100.times do
  Book.create(first_name: Faker::Name.first_name, last_name: Faker::Name.last_name, title: Faker::Lorem.sentence.capitalize, subject: Faker::Lorem.word, published: rand(1900..2015), publisher: Faker::Company.name, page_count: rand(50..2000), price: rand(5..150), description: Faker::Lorem.paragraph, cover_image: Faker::Avatar.image, isbn: rand(1000000000..9999999999999))
end

300.times do
  BookCopy.create(book_id: Book.all.sample.id)
end

50.times do
  checkout = CheckOut.new(checkout_date: Faker::Date.backward(rand(0..20)), user_id: rand(0..49), book_copy_id: rand(0..299), renewal: rand(0..3))
  checkout.due_date = checkout.checkout_date + 21.days
  checkout.save
end

30.times do
  Hold.create(user_id: rand(0..49), book_id: rand(0..99))
end

10.times do
  hold = Hold.all.sample
  hold.pickup_expiry = Faker::Date.forward(rand(0..7))
  hold.save
end