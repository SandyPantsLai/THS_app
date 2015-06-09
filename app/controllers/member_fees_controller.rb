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
    if @member_fee.update(settlement_date: Time.now, notes: member_fee_params["notes"])
      flash[:notice] = "The membership fee was updated."
      @member_fee.user.update(status: "active")
      redirect_to transactions_url
    else
      flash[:alert] = "There was an issue with updating the membership fee."
      redirect_to transactions_url
    end
  end

  def waive
    @member_fee = MemberFee.find(params["id"])
  end

  def destroy
    MemberFee.find(params["id"]).destroy
    flash[:alert] = "The member will have temporary access until their next scheduled membership payment is due"
    redirect_to transactions_url
  end

  private
  def member_fee_params
    params.require(:member_fee).permit(:notes)
  end

end
