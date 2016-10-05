class SessionsController < ApplicationController

  before_action :redirect_if_logged_in, only: [:new]

  def new

  end

  def create
    user = User.find_by_credentials(session_params[:user_name], session_params[:password])

    if user
      login(user)
      redirect_to cats_url
    else
      flash[:errors] = ["we could not log you in"]
      redirect_to new_session_url
    end
  end

  def destroy
    logout(current_user)
    redirect_to cats_url
  end

  private

  def session_params
    params.require(:user).permit(:user_name, :password)
  end
end
