class SessionsController < ApplicationController
  def new
  end
  
  def create
    @user = User.find_by(username: params[:username])
    if @user && @user.authenticate(params[:password])
      log_in(@user)
      flash[:success] = "#{@user.username} logged in"
      redirect_to @user  
    else
      flash.now[:danger] = "Invalid username/password!!!!"
      render 'new'
    end
  end
  
  def destroy
  	flash[:info] = "You have been successfully logged out!"
    cookies.delete :user_id
    redirect_to root_path
  end
  
end
