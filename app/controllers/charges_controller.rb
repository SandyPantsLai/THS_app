class ChargesController < ApplicationController
  before_action :require_login

  def new
    @user = User.find(params[:format]) || current_user
    @transactions = @user.deposits.where("settlement_date IS NULL") + @user.member_fees.where("settlement_date IS NULL")
    @amount = @transactions.sum(&:amount)
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
      t.update(notes: "Online Payment", settlement_date: Time.now, charge_id: charge.id)
      current_deposit = t.user.current_deposit || 0
      t.user.update(current_deposit: current_deposit + @amount) if t.class == Deposit
      @member_fee.user.update(status: "active") if MemberFee.where(user: @member_fee.user).where("settlement_date IS NOT NULL")
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
