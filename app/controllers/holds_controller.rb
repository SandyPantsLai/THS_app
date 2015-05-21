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
    @hold = Hold.new(book_id: params[:book_id])

    if @hold.save
      redirect_to book_path(@hold.book_id)
    else
      render :new
    end
  end

  def destroy
    @hold = hold.find(params[:id])
    @hold.destroy
    redirect_to hold_path
  end
end
