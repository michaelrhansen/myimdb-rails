class HomesController < ApplicationController
  skip_before_filter :login_required, :only=> :index
  
  def index
  end
  
  def show
    @activities = Activity.for_user(current_user)
  end
  
  def public
    @user = User.find_by_twitter_username(params[:username])
    unless @user
      flash[:error] = "User '#{params[:username]}' not found"
      redirect_to home_path
      return
    end
    
    @activities = @user.activities
    render :action=> 'show'
  end
end