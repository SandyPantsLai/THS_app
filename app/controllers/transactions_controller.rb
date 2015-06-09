class TransactionsController < ApplicationController
  before_action :require_login

  def index
    #does admin ever need to see a list of all transactions? or is it ok if they have to look under the user?
    if current_user.role == "admin" || current_user.role == "volunteer"
      @transactions = (Deposit.all + MemberFee.all).sort_by{|transaction|transaction.user.last_name}
    else
      @transactions = current_user.deposits + current_user.member_fees
    end
  end

  def user_transactions
    if params[:user_id]
      @user = User.find(params[:user_id])
    else
      @user = current_user
    end

    @transactions = @user.deposits + @user.member_fees
    flash[:alert] = "No transactions were found for this member" if @transactions == []
    render :index
  end
end
