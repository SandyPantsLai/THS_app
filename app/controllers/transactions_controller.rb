class TransactionsController < ApplicationController
  before_action :require_login

  def index
    #does admin ever need to see a list of all transactions? or is it ok if they have to look under the user?
    @transactions = current_user.deposits + current_user.member_fees
  end

  def edit
  end

  def update
  end

  def destroy
  end
end
