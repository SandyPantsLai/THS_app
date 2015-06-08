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
    current_deposit = @deposit.user.current_deposit || 0
    if @deposit.update(settlement_date: Time.now, notes: params["deposit"]["notes"])
      @deposit.user.update(current_deposit: current_deposit + @deposit.amount)
      flash[:notice] = "The payment has been updated"
      redirect_to user_url(@deposit.user)
    else
      flash[:alert] = "There was an issue with updating the deposit."
      redirect_to transactions_url
    end
  end

  def destroy
  end

end
