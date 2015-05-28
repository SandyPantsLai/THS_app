class UsersController < ApplicationController
	# this controller handle user sign ups

  def index
    @users = User.all
  end

  def new
		@user = User.new
	end

	def create
			@user = User.new(user_params)
			@user.role = 'user'
			if @user.save
				redirect_to root_url, notice: "Sweet gravy user created"
			else
				render 'new'
			end
	end

	def show
    @user = User.find(params[:id])

    check_outs = CheckOut.where( user: @user )

    @current_check_outs = check_outs.where( return_date: nil ).order( :checkout_date )
    @past_check_outs = check_outs.where( return_date: !nil ).order( :return_date )

    @holds = Hold.where( user: @user )

    @total_fine = check_outs.inject( 0 ) do | sum, check_out |
      sum += ( !check_out.fine.nil? && check_out.fine.settlement_date.nil? ) ? check_out.fine.amount : 0
      sum
    end
  end

	def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find( params[ :id ] )

    if @user.update_attributes(user_update_params)
      flash[ :alert ] = "Success"
      redirect_to user_path( @user )
    else
      flash[ :notice ] = "Error"
      render 'edit'
    end
	end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :role)
  end

  def user_update_params
    params.require(:user).permit(:first_name, :last_name, :email, :phone_number, :role)
  end

end