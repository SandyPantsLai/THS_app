require "test_helper"

describe MemberFee do
  let(:member_fee) { MemberFee.new }

  it "must be valid" do
    member_fee.must_be :valid?
  end
end
