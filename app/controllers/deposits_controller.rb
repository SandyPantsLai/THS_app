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
  end

  def destroy
  end

  def initial_deposit(user)
    Deposit.create(amount:4000, user_id: user.id)
  end

  def user_deposits
  end
end
