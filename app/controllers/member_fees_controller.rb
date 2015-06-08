class MemberFeesController < ApplicationController
  def index
    @member_fees = current_user.member_fees
  end

  def edit
    @member_fee = MemberFee.find(params["id"])
    @transactions =[@member_fee]
  end

  def update
    @member_fee = MemberFee.find(params["id"])
    if @member_fee.update(settlement_date: Time.now, notes: params["member_fee"]["notes"])
      redirect_to user_url(@member_fee.user)
    else
      redirect_to transactions_url
    end
  end

  def destroy
  end

end
