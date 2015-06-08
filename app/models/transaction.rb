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
      last_fee = MemberFee.where(user_id: user.id).where(amount <= 1000).last
      if last_fee.settlement_date
        next_billing_date = (t + 1.months).beginning_of_month
        MemberFee.create(amount: 10000, user_id: user.id, created_at: next_billing_date)
        flash[:notice] = "Your next annual payment is due on #{next_billing_date.strftime("%b %e, %Y")}"
      #if it is not already paid, update the last payment to be for the annual price instead
      else
        last_fee.update(amount: 10000)
        flash[:notice] = "Please pay for your annual payment."
      end

    else
      #since new membership is monthly, check for when next payment is actually due
      last_fee = MemberFee.where(user_id: user.id).where(amount > 1000).last
      # time_elapsed = t - last_fee.created_at

      if last_fee.settlement_date
        #check how many months have been paid for but not yet used
        months_left = 12 - (t.month.to_int - last_fee.created_at.month.to_int)
        next_billing_date = t.beginning_of_month + months_left.months
        MemberFee.create(amount: 1000, user_id: user.id, created_at: next_billing_date)
        flash[:notice] = "Your next monthly payment is due on #{next_billing_date.strftime("%b %e, %Y")}"
      else
        last_fee.update(amount: 1000, created_at: t.beginning_of_month)
        flash[:notice] = "Please pay for your monthly payment."
      end
    end
  end

  def self.initial_deposit(user)
    Deposit.create(amount:4000, user_id: user.id)
  end

  def self.top_up_deposit(user)
    if deposit = Deposit.where(user_id: user.id).where(settlement_date: nil)
      deposit.update(amount: 4000 - user.current_deposit, updated_at: Time.now)
    else
      Deposit.create(amount: 4000 - user.current_deposit, user_id: user.id)
    end
  end

end