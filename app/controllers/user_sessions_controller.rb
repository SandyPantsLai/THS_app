class UserSessionsController < ApplicationController
	# This controller handles the login
  def new
  end

  def create

    if @user = login(params[:email], params[:password], params[:remember])
      session[:id] = @user.id 
      redirect_back_or_to(:books, notice: 'Logged In')
    else
      flash.now[:alert] = 'Login Failed'
      render action: 'new'
    end
  end

  def destroy
    logout
    redirect_to(root_url, notice: 'Logged Out')
  end
end