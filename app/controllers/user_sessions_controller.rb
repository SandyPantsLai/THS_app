class UserSessionsController < ApplicationController
	# This controller handles the login
  
  def new
    @user = User.new
  end

  def create
    respond_to do |format|
      if @user = login(params[:email],params[:password],params[:remember])
        format.html { redirect_back_or_to(:users, :notice => 'Login Successfull') }
      else
        format.html { flash.now[:alert] = "Login Failed"; render :action => "new" }
      end
    end
  end

  def destroy
    logout
    redirect_to(root_url, notice: 'Logged Out')
  end
end