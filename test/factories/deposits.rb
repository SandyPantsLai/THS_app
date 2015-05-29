FactoryGirl.define do
  factory :deposit do
    amount 4000
    user
    settlement_date Time.now
    charge_id nil
  end
end