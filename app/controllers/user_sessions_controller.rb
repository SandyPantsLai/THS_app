class UserSessionsController < ApplicationController
	# This controller handles the login
  
  def new
    @user = User.new
  end

  def create
    if @user = login(params[:email], params[:password], params[:remember_me])
      format.html {redirect_to books_path(:notice => "Login Successful")}
    else
      format.html {flash.now[:alert] = "E-mail and/or password is incorrect"; render :action => 'new'}
    end
  end

  def destroy
    logout
    redirect_to(root_url, notice: 'Logged Out')
  end
end