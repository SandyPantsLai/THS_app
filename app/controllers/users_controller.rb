class UsersController < ApplicationController
	# this controller handle user sign ups
	def new
		@user = User.new
	end

	def create
			@user = User.new(user_params)
			@user.role = 'user'
			if @user.save
				redirect_to root_url, notice: "You have signed up"
			else
				render 'new'
			end
	end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :role)
  end
end