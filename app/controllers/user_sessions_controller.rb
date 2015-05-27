class UserSessionsController < ApplicationController
	# This controller handles the login
  
  def new
    @user = User.new
  end

  def create
    if login(params[:email], params[:password], params[:remember_me])
      flash[:success] = 'Welcome!'
      redirect_back_or_to root_path
    else
      flash.now[:warning] = 'E-mail and/or password is incorrect.'
      render 'new'
    end
  end

  def destroy
    logout
    redirect_to(root_url, notice: 'Logged Out')
  end
end