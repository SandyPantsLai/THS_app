# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

10.times do
   Subject.create(name: Faker::Lorem.word)
end

User.create!(
    first_name: "Johnny",
    last_name: "Adminseed",
    email: "god@ths.com",
    password: '1234',
    password_confirmation: '1234',
    role: 'admin',
    current_deposit: 4000,
)

User.create!(
    first_name: "Mere",
    last_name: "Thing",
    email: "minion@ths.com",
    password: '4321',
    password_confirmation: '4321',
    role: 'user',
    current_deposit: 2750,
)

10.times do
	User.create!(first_name: Faker::Name.first_name, last_name: Faker::Name.last_name, email: Faker::Internet.email, phone_number: Faker::PhoneNumber.phone_number, password: '4321', password_confirmation: '4321', role: 'user')
end

MemberFee.create(amount: 10000, user_id: 1, settlement_date: Time.now - 14.days)
MemberFee.create(amount: 1000, user_id: 3, settlement_date: Time.now - 58.days, created_at: Time.now-58.days)
MemberFee.create(amount: 1000, user_id: 3, created_at: Time.now - 28.days)

Deposit.create(amount: 4000, user_id: 1, settlement_date: Time.now - 14.days)
Deposit.create(amount: 4000, user_id: 3, settlement_date: Time.now - 28.days)
Deposit.create(amount: 1250, user_id: 3)

100.times do
  Book.create(first_name: Faker::Name.first_name, last_name: Faker::Name.last_name, title: Faker::Lorem.sentence.capitalize, published_date: rand(1900..2015), publisher: Faker::Company.name, page_count: rand(50..2000), description: Faker::Lorem.paragraph, subject_id: rand(1..10), cover_image: Faker::Avatar.image)
end

300.times do
  BookCopy.create(book_id: rand(2..99))
end

5.times do
  BookCopy.create(book_id: 1)
end

30.times do
  Hold.create(user_id: rand(1..12), book_id: rand(1..15))
end

2.times do
  Hold.create(user_id: rand(1..12), book_id: 1, pickup_expiry: Faker::Date.forward(rand(0..7)))
end

50.times do
  checkout = CheckOut.new(checkout_date: Faker::Date.backward(rand(0..20)), user_id: rand(1..12), book_copy_id: rand(1..300), renewal: rand(0..1))
  checkout.due_date = checkout.checkout_date + 7.days
  checkout.save
end


checkout = CheckOut.new(checkout_date: Faker::Date.backward(rand(0..20)),
  user_id: rand(1..12),
  book_copy_id: 301,
  renewal: rand(0..1))
checkout.due_date = checkout.checkout_date + 7.days
checkout.save

checkout = CheckOut.new(checkout_date: Faker::Date.backward(rand(0..20)),
  user_id: rand(1..12),
  book_copy_id: 302,
  renewal: rand(0..1))
checkout.due_date = checkout.checkout_date + 7.days
checkout.save

checkout = CheckOut.new(checkout_date: Faker::Date.backward(rand(0..20)),
  user_id: rand(1..12),
  book_copy_id: 303,
  renewal: rand(0..1))
checkout.due_date = checkout.checkout_date + 7.days
checkout.save




