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
    @copies = BookCopy.where(book_id: params[:book_id])
    @checked_out = 0
    @copies.each do |copy|
      @checkout = CheckOut.find_by(book_copy_id: copy.id)
      if @checkout
        @checked_out += 1
      end
    end

    if @copies.count - @checked_out - Hold.where(book_id: params[:book_id]).where("pickup_expiry IS NOT NULL").count == 0
      pickup_expiry = nil
    else
      pickup_expiry = Time.now + 7.days
    end

    @hold = Hold.new(book_id: params[:book_id], user_id: current_user.id, pickup_expiry: pickup_expiry)

    if @hold.save
      if pickup_expiry == nil
        flash[:notice] = "You are ##{Hold.where(book_id: @hold.book_id).count} in line."
      else
        flash[:notice] = "You have until #{pickup_expiry.strftime("%A, %b %e, %Y")} to pick up your book."
      end
      redirect_to book_path(@hold.book_id)
    else
      flash[:alert] = "We were unable to confirm your hold due to these errors: #{@hold.errors.full_messages}"
      render :new
    end
  end

  def destroy
    @hold = Hold.find(params[:id])
    next_hold = Hold.where(book_id: @hold.book_id).where("pickup_expiry IS NULL").first
    next_hold.pickup_expiry = Time.now + 7.days
    @hold.destroy
    flash[:notice] = "Your hold has been cancelled."
    redirect_to holds_path
  end

  def my_holds
    @holds = Hold.where(user_id: current_user.id)
    render :index
  end
end
