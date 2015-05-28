class ChargesController < ApplicationController
  before_action :require_login

  def index
    #lists a user's payment history or all user history if admin
  end

  def new
  end

  def create
    # Get the credit card details submitted by the form
    Stripe.api_key = "sk_test_gTH1VjVzQY3iFpr10fYocO0L"
    @amount = 1000

    # Create a Customer
    unless current_user.stripe_id
      customer = Stripe::Customer.create(
        :source => params[:stripeToken]
      )
    end

    # Save the customer ID in your database so you can use it later
    current_user.update(stripe_id: customer.id)

    # Charge the Customer (no card info is stored, card is charged using token)
    charge = Stripe::Charge.create(
          :customer => current_user.stripe_id,
          :amount => @amount, # in cents
          :currency => "cad",
      )

    flash[:notice] = "Thanks for your payment!"
    redirect_to user_path(current_user)

    rescue Stripe::CardError => e
      flash[:alert] = e.message
      redirect_to charges_path
  end
end
