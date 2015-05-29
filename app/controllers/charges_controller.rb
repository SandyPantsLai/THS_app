class ChargesController < ApplicationController
  before_action :require_login

  def new
    # @payment = Payment.find(params[:payment_id])
    # @charge_for = current_user.fines.sum + current_user.member_fees.sum
  end

  def create
    # Get the credit card details submitted by the form

    # Create a Stripe Customer and save card info as token for reuse
    if current_user.stripe_id == nil && params[:remember_card] == "on"
      customer = Stripe::Customer.create(
        :source => params[:stripeToken]
      )
      current_user.update(stripe_id: customer.id)

      charge = Stripe::Charge.create(
          :customer => current_user.stripe_id,
          :amount => 1000, # in cents
          :currency => "cad",
      )
    else
    # Charge the Customer (no card info is stored, card is charged using token)
      charge = Stripe::Charge.create(
      :source => params[:stripeToken],
      :amount => 1000, # amount in cents, again
      :currency => "cad",
      # :description => "Example charge"
    )
    end

    flash[:notice] = "Thanks for your payment!"
    redirect_to user_path(current_user)

    rescue Stripe::CardError => e
      flash[:alert] = e.message
      redirect_to charges_path
  end
end
