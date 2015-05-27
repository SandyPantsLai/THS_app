FactoryGirl.define do
  factory :book do
    sequence(:title) { |n| "Title for Book #{n}" }
  end
end