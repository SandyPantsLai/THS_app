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
				redirect_to root_url, notice: "User created"
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
  end

	def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find( params[:id])

    if @user.update_attributes(user_update_params)
      flash[ :alert ] = "Success"
      redirect_to user_path(@user)
    else
      flash[ :notice ] = "Error"
      render 'edit'
    end
	end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
  end

  def user_update_params
    params.require(:user).permit(:first_name, :last_name, :email, :phone_number)
  end

end