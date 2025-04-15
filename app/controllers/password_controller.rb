class PasswordController < ApplicationController
  layout false, only: [:forgot, :reset_code, :reset]
  skip_before_action :authenticate_user!, only: [
  :forgot, 
  :send_reset_code, 
  :reset_code, 
  :verify_reset_code, 
  :resend_reset_code, 
  :reset, 
  :update
  ]

  require 'securerandom'
  def new
      super
  end

  def create
      super
  end

  def forgot
    render 'password/forgot'
  end

  def send_reset_code
    @user = User.find_by(email: params[:email])
    if @user
      @user.update_columns(reset_code: SecureRandom.hex(3), reset_sent_at: Time.now)

      session[:reset_user_id] = @user.id
      
      # Send email
      UserMailer.reset_password_email(@user).deliver_now

      flash[:notice] = "Reset code sent to your email."
      redirect_to reset_code_path
    else
      flash[:error] = "User not registered in the database"
      redirect_to forgot_password_path 
    end
  end

  def reset_code
    render 'password/reset_code'
  end

  def verify_reset_code
    if current_reset_user&.reset_sent_at&.>(15.minutes.ago) && current_reset_user&.reset_code == params[:reset_code]
      redirect_to new_password_reset_path
    else
      flash[:console_alert] = "Invalid or expired reset code"
      redirect_to reset_code_path
    end
  end

  def resend_reset_code
    if current_reset_user
      current_reset_user.update_columns(reset_code: SecureRandom.hex(3), reset_sent_at: Time.now)
      
      # Send email again
      UserMailer.reset_password_email(current_reset_user).deliver_now

      flash[:notice] = "New reset code sent to your email."
      redirect_to reset_code_path
    else
      flash[:console_alert] = "Session expired. Please request a new reset code."
      redirect_to forgot_password_path
    end
  end

  def reset
    @user=current_reset_user
    render 'password/reset'
  end

  def update
    @user=current_reset_user
    if @user.update(password_params.merge(reset_code: nil))
      session[:reset_user_id] = nil
      flash[:notice] = "Password reset successful!"
      redirect_to new_user_session_path
    else
      render 'password/reset',status: :unprocessable_entity
    end
  end

  private

  def current_reset_user
    @current_reset_user ||= User.find_by(id: session[:reset_user_id])
  end

  def password_params
    params.require(:user).permit(:password, :password_confirmation)
  end

end
