class UsersController < ApplicationController

  before_action :redirect_if_logged_in, only: [:new]

  def new
  end

  def create
    user = User.new(user_params)

    if user.save
      login(user)
      redirect_to cats_url
    else
      flash[:errors] = user.errors.full_messages
      redirect_to new_user_url
    end
  end

  def destroy
  end

  private

  def user_params
    params.require(:user).permit(:user_name, :password)
  end
end
