class HoldsController < ApplicationController
  def index
      @holds = Hold.all
  end

  def show
    @hold = Hold.find(params[:id])

    if current_user
      @review = @hold.reviews.build
    end
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

  def edit
    @hold = hold.find(params[:id])
  end

  def update
    @hold = hold.find(params[:id])
    if @hold.update_attributes(hold_params)
      redirect_to hold_path(@hold)
    else
      render :edit
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