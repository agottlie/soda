class UsersController < ApplicationController
    before_action :require_user, only: [:show, :index]
  	before_action :require_current_user, only: [:show]

    def search
    	@users = User.where('LOWER(name) LIKE ?', "%#{params[:q].downcase}%").order(:name)
    	render :json => {:users => @users}
  	end

    def profile
      @user = @require_current_user
      render "users#show"
    end

  	def show
    	@user = User.find(params[:id])
  	end
<<<<<<< HEAD
    def edit
      @user = User.find(params[:id])
      
    end
=======
>>>>>>> e6cc03f9236f1e087437f67f8f654ee184453782

  	def new
   		@user = User.new
  	end

  	def create
   		@user = User.new(user_params)
   		# @user.avatar = "https://www.gravatar.com/avatar/#{Digest::MD5.hexdigest(@user.email)}?d=identicon&f=y"
   		if @user.save
     	  session[:user_id] = @user.id
     	  redirect_to @user
   		else
     	  redirect_to '/signup'
   		end
 	  end

  	private

   	def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
   	end

end