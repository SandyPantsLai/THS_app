class HoldsController < ApplicationController
  before_action :require_login

  def index
    if current_user.role == "admin" || current_user.role == "volunteer"
      @holds = Hold.all
    else
      @holds = Hold.where(user_id: current_user.id)
    end
  end

  def new
    @hold = Hold.new
    @hold.book_id = params[:book_id]
  end

  def create
    @hold = Hold.new(book_id: params[:book_id], user_id: current_user.id)

    if @hold.save
      flash[:notice] = "You are #{Hold.where(book_id: @hold.book_id).count} in line."
      redirect_to book_path(@hold.book_id)
    else
      flash[:alert] = "We were unable to confirm your hold due to these errors: #{@hold.errors.full_messages}"
      render :new
    end
  end

  def destroy
    @hold = hold.find(params[:id])
    @hold.destroy
    redirect_to holds_path
  end

  def my_holds
    @holds = Hold.where(user_id: current_user.id)
    render :index
  end
end
