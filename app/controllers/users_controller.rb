class UsersController < ApplicationController
	# this controller handle user sign ups

  def index
    @users = User.all.sort_by{|user| user.last_name}
  end

  def new
		@user = User.new
	end

	def create
			@user = User.new(user_params)
			@user.role = 'user'
			if @user.save
        Transaction.new_membership(@user)
        Transaction.initial_deposit(@user)
				redirect_to transactions_path, notice: "User created.  Please enter payments for the deposit and membership fee."
			else
				render 'new'
			end
	end

  skip_before_filter :require_login, :only => [:index, :new, :create, :activate]

  def activate
    if (@user = User.load_from_activation_token(params[:id]))
      @user.activate!
      redirect_to(login_path, :notice => 'Your account was successfully activated')
    else
      not_authenticated
    end
  end


	def show
    @user = User.find(params[:id])

    check_outs = CheckOut.where( user: @user )

    @current_check_outs = check_outs.where( return_date: nil ).order( :checkout_date )
    @past_check_outs = check_outs.where( "return_date IS NOT NULL" ).order( :return_date )

    @holds = Hold.where( user: @user )

    @total_fine = check_outs.inject( 0 ) do | sum, check_out |
      sum += ( !check_out.fine.nil? && check_out.fine.settlement_date.nil? ) ? check_out.fine.amount : 0
      sum
    end

    @transactions = @user.deposits.where("settlement_date IS NULL") + @user.member_fees.where("settlement_date IS NULL")
  end

	def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find( params[:id])

    @change_membership = true if params[:membership] != @user.membership

    if @user.update_attributes(user_update_params)
      Transaction.update_member_fee(@user) if @change_membership
      flash[ :alert ] = "Success"
      redirect_to user_path(@user)
    else
      flash[ :notice ] = "Error"
      render 'edit'
    end
	end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :membership)
  end

  def user_update_params
    params.require(:user).permit(:first_name, :last_name, :email, :phone_number, :membership)
  end

end