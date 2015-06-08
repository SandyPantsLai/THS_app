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
  end

  def update
    @deposit = Deposit.find(params["id"])
    @deposit.update(settlement_date: Time.now, notes: params["deposit"]["notes"])
    binding.pry
    redirect_to transactions_path
  end

  def destroy
  end

end
