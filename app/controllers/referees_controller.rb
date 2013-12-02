class RefereesController < ApplicationController
  def new
    @referee = current_user.referees.build
  end
  
  def create
   @referee = current_user.referees.build(acceptable_params)
    if @referee.save
      flash[:success]="Referee created!"
      redirect_to 'referees/show'
    else
      flash[:danger]="Invalid!"
      render 'new'
    end
  end    
  
  def show
    @referee = Referee.find(params[:id])
  end
  def update
    if @referee.update_attributes(acceptable_params)
      flash[:success] = "Referee #{@referee.name} updated successfully!"
      redirect_to @referee
    else
      render 'edit'
    end
  end
  
   def destroy
    @referee = Referee.find(params[:id])
    if current_user?(@referee.user) #|| current_user.admin?
      @referee.destroy
      flash[:success] = "Referee destroyed."
      redirect_to referees_path
    else
      flash[:danger] = "Can't delete referee."
      redirect_to root_path
    end 
  end
  
  
  private
  def acceptable_params
    params.require(:referee).permit(:name, :ruels_url, :players_per_game, :upload)
  end
   def ensure_correct_user
      @referee = Referee.find(params[:id])
      redirect_to root_path, flash: { :danger => "Must be Logged in as correct user!" } unless current_user?(@referee.user)
    end 
   
    def ensure_user_logged_in
     redirect_to login_path, flash: { :warning => "Unable, please log in!" } unless logged_in? 
    end
    
    def ensure_contest_creator 
      redirect_to root_path, flash: { :danger => "You are not a contest creator!" } unless current_user.contest_creator?
    end
       
end
