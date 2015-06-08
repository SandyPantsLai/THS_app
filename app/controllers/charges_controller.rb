require 'json'

class ChargesController < ApplicationController
  before_action :require_login

  def new
    user = User.find(params[:format]) || current_user
    @transactions = user.deposits.where("settlement_date IS NULL") + user.member_fees.where("settlement_date IS NULL")
    @amount = @transactions.sum(&:amount)
    @pay_now = true
  end

  def create
    # Get the credit card details submitted by the form
    @transactions = current_user.deposits.where("settlement_date IS NULL") + current_user.member_fees.where("settlement_date IS NULL")
    @amount = @transactions.sum(&:amount)
    # Create a Stripe Customer and save card info as token for reuse
    if current_user.stripe_id == nil && params[:remember_card] == "on"
      customer = Stripe::Customer.create(
        :source => params[:stripeToken]
      )
      current_user.update(stripe_id: customer.id)

      charge = Stripe::Charge.create(
          :customer => current_user.stripe_id,
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
      t.update(notes: charge.id, settlement_date: Time.now)
      if t.class == Deposit
        t.user.update(current_deposit: t.user.current_deposit + @amount)
      end
    end

    flash[:notice] = "Thanks for your payment!"
    redirect_to transactions_path

    rescue Stripe::CardError => e
      flash[:alert] = e.message
      redirect_to charges_path
  end

  def show
    @charge = Stripe::Charge.retrieve(params[:id])
    @transactions = current_user.deposits.where(notes: @charge.id) + current_user.member_fees.where(notes: @charge.id)
  end

  def confirm_refund
    @charge = Stripe::Charge.retrieve(params[:format])
    @transactions = current_user.deposits.where(notes: @charge.id) + current_user.member_fees.where(notes: @charge.id)
  end

  def refund
    @charge = Stripe::Charge.retrieve(params[:format])
    @charge.refunds.create
    @transactions = current_user.deposits.where(notes: @charge.id) + current_user.member_fees.where(notes: @charge.id)
    @transactions.each do |t|
      t.update(settlement_date: nil)
      if t.class == Deposit
        t.user.update(current_deposit: t.user.current_deposit - @charge.amount)
      end
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
