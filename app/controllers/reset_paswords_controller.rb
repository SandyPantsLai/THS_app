class ResetPaswordsController < ApplicationController
	skip_before_filter :require_login

	def new
	end

	def create
  	@user = User.find_by_email(params[:email])
  	@user.deliver_reset_password_instructions! if @user
  	flash[:success] = 'Password reset instructions have been sent to your email.'
  	redirect_to log_in_path
	end
end
