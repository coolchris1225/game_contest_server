class UsersController < ApplicationController
  
  def index
    @users = User.all
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(permittedparams)
    
    if @user.save then
      flash[:success] = "Welcome to the site: #{@user.username}"
      redirect_to @user
    else
      render 'new'
    end
  end
  
  def show
    @user = User.find(params[:id])
  end

  def edit 
    @user = User.find(params[:id])
  end
    
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(permittedparams)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to users_path      
  end
    
    
  private
    def permittedparams
      permittedparams = params.require(:user).permit(:username,:password,:password_confirmation,:email)
    end    
end