class UsersController < ApplicationController
  layout false, only: [:new]
  def new
    @user = User.new  # Initialize a new User object
  end

  def create
    @user = User.new(user_params)
    if @user.save
      puts 'user saved'
      redirect_to new_user_session_path, notice: "Account created successfully! Please log in"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
