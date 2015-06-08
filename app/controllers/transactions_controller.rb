class TransactionsController < ApplicationController
  before_action :require_login

  def index
    #does admin ever need to see a list of all transactions? or is it ok if they have to look under the user?
    if current_user.role == "admin" || current_user.role == "volunteer"
      @admin_transactions = current_user.deposits + current_user.member_fees
      @transactions = Deposit.all + MemberFee.all - @admin_transactions
    else
      @transactions = current_user.deposits + current_user.member_fees
    end
  end

  def edit
    if t.class == MemberFee
      @transactions = [MemberFee.find(params[:id])]
    else
      @transactions = [Deposit.find(params[:id])]
    end
  end

  def destroy
  end

  def user_transactions
    @user = User.find(params[:id])
    @transactions = @user.deposits + @user.member_fees
    render :index
  end
end
