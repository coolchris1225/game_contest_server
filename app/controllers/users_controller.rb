class UsersController < ApplicationController
  before_action :ensure_user_logged_in, only: [:edit, :update]
  before_action :ensure_correct_user, only: [:edit, :update]
  before_action :ensure_admin_user, only: [:destroy]
  before_action :ensure_not_logged_in, only: [:new, :create]
  respond_to :html, :json, :xml
  
  def index
    @users = User.all
    respond_with(@users)
  end
  
  def new
    @user = User.new
    respond_with(@user)
  end
  
  def create
    @user = User.new(user_params)
    if @user.save then
      log_in(@user)
      flash[:success] = "Welcome #{@user.username}"
    end
    respond_with(@user)
  end
    
  def destroy
    @user.destroy
    flash[:success] = "User deleted."      
    respond_with(@user)
  end
  
  def edit
  end
    
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Your account #{@user.username} was updated successfully!"
    end
    respond_with(@user)
  end
    
  def show
    @user = User.find(params[:id])
    respond_with(@user)
  end
    
  private
    def user_params
      params.require(:user).permit(:username, :email, :password, :password_confirmation)
    end
    
    def ensure_admin_user
      @user = User.find(params[:id])
      if !current_user.admin? || current_user?(@user)
        redirect_to root_path, flash: { :danger => "Error: Your must be an admin!" }
      end
    end
   
    def ensure_user_logged_in
     redirect_to login_path, flash: { :warning => "Error Unable, please log in!" } unless logged_in? 
    end
    
    def ensure_correct_user
      @user = User.find(params[:id])
      redirect_to root_path, flash: { :danger => "Error: please log in!" } unless current_user?(@user)
    end
    
    def ensure_not_logged_in
      redirect_to root_path, flash: { :warning => "Error!" } unless !logged_in?
    end
    
end