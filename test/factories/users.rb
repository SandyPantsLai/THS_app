FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "minion#{n}@ths.com" }
    first_name Faker::Name.last_name
    last_name Faker::Name.last_name
    password "4321"
    password_confirmation {|u| u.password }
  end

  factory :admin, class: User do
    sequence(:email) { |n| "god#{n}@ths.com" }
    first_name Faker::Name.last_name
    last_name "Administrator"
    role "admin"
    password "1234"
    password_confirmation {|u| u.password }
  end
end