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
      flash[:notice] = "The membership fee was updated."
      redirect_to user_url(@member_fee.user)
    else
      flash[:alert] = "There was an issue with updating the membership fee."
      redirect_to transactions_url
    end
  end

  def waive
    @member_fee = MemberFee.find(params["id"])
  end

end
