class MemberFeesController < ApplicationController
  def index
    @member_fees = current_user.member_fees
  end

  def edit
  end

  def update
  end

  def destroy
  end

end
