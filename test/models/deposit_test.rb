require "test_helper"

describe Deposit do
  let(:deposit) { Deposit.new }

  it "must be valid" do
    deposit.must_be :valid?
  end
end
