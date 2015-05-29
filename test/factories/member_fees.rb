FactoryGirl.define do
  factory :member_fee do
    amount 1000
    user
    settlement_date nil
    charge_id nil
  end
end