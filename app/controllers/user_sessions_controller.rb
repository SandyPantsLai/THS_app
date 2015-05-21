class UserSessionsController < ApplicationController
	# This controller handles the login
  def new
  end

  def create

    if @user = login(params[:email], params[:password])
      session[:id] = @user.id #test
      redirect_back_or_to(:books, notice: 'Login successful')
    else
      flash.now[:alert] = 'Login failed'
      render action: 'new'
    end
  end

  def destroy
    logout
    redirect_to(root_url, notice: 'Log out successful')
  end
end