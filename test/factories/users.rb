FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "minion#{n}@ths.com" }
    password "4321"
    password_confirmation {|u| u.password }
  end

  factory :admin, class: User do
    email "god@ths.com"
    role "admin"
    password "1234"
    password_confirmation {|u| u.password }
  end
end