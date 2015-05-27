FactoryGirl.define do
  factory :check_out do
    checkout_date { Faker::Date.backward(rand(0..7)) }
    due_date { checkout_date + 7.days }
    user
    book_copy
  end
end