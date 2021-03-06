class SessionsController < ApplicationController
	protect_from_forgery with: :exception
	
	def new
		
	end

	def create
		@user = User.find_by(:email => params[:session][:email])
		if @user && @user.authenticate(params[:session][:password])
			puts "Hello"
			session[:user_id] = @user.id
			redirect_to @user
		else
			redirect_to login_path
		end
	end

	def destroy
		session[:user_id] = nil
		redirect_to login_path
	end
end
