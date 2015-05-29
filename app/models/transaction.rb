class Transaction

  def self.new_membership(user)
    t = Time.now
    days_in_month = t.end_of_month.day * 100 #multiplied by 100 to avoid decimal in division
    prorate = (days_in_month - t.day * 100)/days_in_month

    if user.membership == "annual"
      #This divides the annual cost by 12 months and prorates the current month while adding rest of membership in full for the next 11 months.  This allows the next billing date to be the start of the current month of the next year.
      MemberFee.create(amount: ((10000.0 / 12.0 * 11.0) + (10000 * prorate / 100)).to_int, user_id: user.id)
    else
      MemberFee.create(amount: 1000 * prorate / 100, user_id: user.id)
    end
  end

  def self.initial_deposit(user)
    Deposit.create(amount:4000, user_id: user.id)
  end

  def self.user_deposits
  end

end