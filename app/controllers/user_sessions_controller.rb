class UserSessionsController < ApplicationController
	# This controller handles the login
  def new
  end

  def create
    if @user = login(params[:username], params[:password], params[:remember])
      redirect_back_or_to(:users, notice: 'Login successful')
    else
      flash.now[:alert] = 'Login failed'
      render action: 'new'
    end
  end

  def destroy
    logout
    redirect_to(:users, notice: 'Logged out!')
  end
end