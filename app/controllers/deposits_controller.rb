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
    @deposit.update(settlement_date: Time.now, notes: params["deposit"]["notes"])
    @deposit.user.update(current_deposit: @deposit.user.current_deposit + params["deposit"]["amount"])
    redirect_to transactions_url
  end

  def destroy
  end

end
