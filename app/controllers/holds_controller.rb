class HoldsController < ApplicationController
  def index
    if current_user.role = "admin"
      @holds = Hold.all
    else
      @holds = Hold.where(user_id: current_user.id)
    end
  end

  def show
    @hold = Hold.find(params[:id])
  end

  def new
    @hold = Hold.new
    @hold.book_id = params[:book_id]
  end

  def create
    @hold = Hold.new(hold_params)

    if @hold.update(hold_params)
      redirect_to hold_path(@hold)
    else
      render :new
    end
  end

  def destroy
    @hold = hold.find(params[:id])
    @hold.destroy
    redirect_to hold_path
  end

  private

  def hold_params
    params.require(:hold).permit(:book_id)
  end
end
