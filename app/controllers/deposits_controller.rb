class DepositsController < ApplicationController
  before_action :require_login
  def index
    if current_user.role == "admin" || current_user.role == "volunteer"
      @deposits = Deposit.all
    else
      @deposits = current_user.deposits
    end
  end

  def edit
    @deposit = Deposit.find(params["id"])
    @transactions = [@deposit]
  end

  def update
    @deposit = Deposit.find(params["id"])
    check_outs = CheckOut.where( user: user )
    fines = check_outs.inject( 0 ) do | sum, check_out |
      sum += ( !check_out.fine.nil? && check_out.fine.settlement_date.nil? ) ? check_out.fine.amount : 0
      sum
    end
    current_deposit = @deposit.user.current_deposit

    if @deposit.update(settlement_date: Time.now, notes: params["deposit"]["notes"])
      @deposit.user.update(current_deposit: current_deposit + @deposit.amount - fines, status: "active")
      flash[:notice] = "The payment has been updated"
      redirect_to user_url(@deposit.user)
    else
      flash[:alert] = "There was an issue with updating the deposit."
      redirect_to transactions_url
    end
  end

  def destroy
    deposit = Deposit.find(params["id"])
    user = deposit.user
    user.update(current_deposit: user.current_deposit - deposit.amount)
    deposit.destroy
    flash[:alert] = "The member will have temporary access before they must top up their deposit again tomorrow."
    redirect_to transactions_url
  end
end
