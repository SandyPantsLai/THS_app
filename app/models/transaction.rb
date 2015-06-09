class Transaction

  def self.new_membership(user)
    t = Time.now
    days_in_month = t.end_of_month.day.to_f #multiplied by 100 to avoid decimal in division
    prorate = (days_in_month - t.day).to_f/days_in_month

    if user.membership == "annual"
      #This divides the annual cost by 12 months and prorates the current month while adding rest of membership in full for the next 11 months.  This allows the next billing date to be the start of the current month of the next year.
      MemberFee.create(amount: ((10000.0 / 12.0 * 11.0) + (1000.0 * prorate)).to_int, user_id: user.id)
    else
      MemberFee.create(amount: (1000.0 * prorate).to_int, user_id: user.id)
    end
  end

  def self.update_member_fee(user)
    t = Time.now
    if user.membership == "annual"
      #since new membership is annual, check if this month's payment was already paid
      last_fee = MemberFee.where(user_id: user.id).where("amount <= ?", 1000).last
      if last_fee.settlement_date
        next_billing_date = (t + 1.months).beginning_of_month
        MemberFee.create(amount: 10000, user_id: user.id, created_at: next_billing_date)
      #if it is not already paid, update the last payment to be for the annual price instead
      else
        last_fee.update(amount: 10000)
      end

    else
      #since new membership is monthly, check for when next payment is actually due
      last_fee = MemberFee.where(user_id: user.id).where("amount > ?", 1000).last
      # time_elapsed = t - last_fee.created_at

      if last_fee.settlement_date
        #check how many months have been paid for but not yet used
        months_left = 12 - (t.month.to_int - last_fee.created_at.month.to_int)
        next_billing_date = t.beginning_of_month + months_left.months
        MemberFee.create(amount: 1000, user_id: user.id, created_at: next_billing_date)
      else
        last_fee.update(amount: 1000, created_at: t.beginning_of_month)
      end
    end
  end

  def self.create_member_fee(user)
    if user.membership == "monthly"
      amount = 1000
    else
      amount = 10000
    end
    MemberFee.create(amount: amount, user: user)
  end

  def self.initial_deposit(user)
    Deposit.create(amount:4000, user_id: user.id)
  end

  def self.top_up_deposit(user)
    last_deposit = user.deposits.last

    check_outs = CheckOut.where( user: user )
    fines = check_outs.inject( 0 ) do | sum, check_out |
      sum += ( !check_out.fine.nil? && check_out.fine.settlement_date.nil? ) ? check_out.fine.amount : 0
      sum
    end

    if last_deposit
      unless last_deposit.settlement_date
        last_deposit.update(amount: fines + 4000 - user.current_deposit, created_at: Time.now)
      end
    else
      Deposit.create(amount: fines + 4000 - user.current_deposit, user: user)
    end
    user.update(status: "inactive")
  end

end