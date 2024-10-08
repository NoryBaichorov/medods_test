class UsersController < ApplicationController
  def create
    @user = User.new(user_params)

    if @user.save
      render json: @user, status: :ok
    else
      render json: { message: @user.errors.full_messages.join(' ') }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password)
  end
end
