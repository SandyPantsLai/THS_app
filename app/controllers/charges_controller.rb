class ChargesController < ApplicationController
  before_action :require_login

  def new
    @user = User.find(params[:format]) || current_user
    @transactions = @user.deposits.where("settlement_date IS NULL") + @user.member_fees.where("settlement_date IS NULL")
    @amount = @transactions.sum(&:amount)
    binding.pry
  end

  def create
    # Get the credit card details submitted by the form
    @user = User.find(params[:user_id]) || current_user
    @transactions = @user.deposits.where("settlement_date IS NULL") + @user.member_fees.where("settlement_date IS NULL")
    @amount = @transactions.sum(&:amount)
    # Create a Stripe Customer and save card info as token for reuse
    if @user.stripe_id == nil && params[:remember_card] == "on"
      customer = Stripe::Customer.create(
        :source => params[:stripeToken]
      )
      @user.update(stripe_id: customer.id)

      charge = Stripe::Charge.create(
          :customer => @user.stripe_id,
          :amount => @amount, # in cents
          :currency => "cad",
      )
    else
    # Charge the Customer (no card info is stored, card is charged using token)
      charge = Stripe::Charge.create(
      :source => params[:stripeToken],
      :amount => @amount, # amount in cents, again
      :currency => "cad",
      # :description => "Example charge"
    )
    end

    @transactions.each do |t|

    check_outs = CheckOut.where( user: t.user )
    fines = check_outs.inject( 0 ) do | sum, check_out |
      sum += ( !check_out.fine.nil? && check_out.fine.settlement_date.nil? ) ? check_out.fine.amount : 0
      sum
    end

      t.update(notes: "Online Payment", settlement_date: Time.now, charge_id: charge.id)
      current_deposit = t.user.current_deposit || 0
      t.user.update(current_deposit: current_deposit + @amount - fines, status: "active") if t.class == Deposit
      t.user.update(status: "active") unless t.user.member_fees.last.settlement_date == nil
    end

    flash[:notice] = "Thanks for your payment!"
    redirect_to transactions_path

    rescue Stripe::CardError => e
      flash[:alert] = e.message
      redirect_to charges_path
  end

  def show
    @charge = Stripe::Charge.retrieve(params[:id])
    @transactions = Deposit.where(charge_id: @charge.id) + MemberFee.where(charge_id: @charge.id)
    binding.pry
  end

  def confirm_refund
    @charge = Stripe::Charge.retrieve(params[:format])
    @transactions = Deposit.where(charge_id: @charge.id) + MemberFee.where(charge_id: @charge.id)
  end

  def refund
    @charge = Stripe::Charge.retrieve(params[:format])
    @charge.refunds.create
    @transactions = Deposit.where(charge_id: @charge.id) + MemberFee.where(charge_id: @charge.id)
    @transactions.each do |t|
      t.update(settlement_date: nil)
      t.user.update(current_deposit: t.user.current_deposit - @charge.amount) if t.class == Deposit
      t.user.update(status: "inactive") if t.user.current_deposit < 3500
    end
    flash[:notice] = "Your refund was successful!"
    redirect_to transactions_path

    rescue Stripe::CardError => e
    rescue Stripe::InvalidRequestError => e
    rescue Stripe::StripeError => e
      flash[:alert] = e.message
      redirect_to charges_path(@charge.id)
  end
end
