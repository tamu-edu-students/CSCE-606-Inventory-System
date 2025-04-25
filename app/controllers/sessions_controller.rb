class SessionsController < Devise::SessionsController
  layout ->(controller) {
  controller.action_name.in?(%w[new create]) ? false : 'application'
}
  before_action :redirect_if_authenticated, only: [:new]
  skip_before_action :require_no_authentication, only: [:new]

  def new
    super
  end

  def create
    #puts params.inspect
    user = User.find_by(email: params[:user][:email]) # Ensure correct parameter format

    if user && user.valid_password?(params[:user][:password]) # Devise method to check password
      sign_in(:user, user) # ✅ Fix: Specify the scope
      #sign_in(user)

      # ✅ Track Login Event
      Session.create(user: user, login_time: Time.current)

      # Retrieve the stored location BEFORE redirecting
      redirect_to after_sign_in_path_for(user), notice: "Signed in successfully!"
    else
      flash.now[:alert] = "Invalid Email or password."
      self.resource = User.new # ✅ Ensure the form reloads with a valid resource
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    if current_user
    # ✅ Find last session & update logout time
    user_session = Session.where(user_id: current_user.id).last
    user_session.update(logout_time: Time.current) if user_session.present?

    sign_out(current_user)# Devise method to log out
    reset_session  # ✅ Clears all session data (including stored locations)
    redirect_to new_user_session_path, notice: "Logged out successfully"
    end
  end

  private

  # Prevent already logged-in users from accessing login/signup pages
  def redirect_if_authenticated
    if user_signed_in? 
      flash[:console_alert] = "You are already signed in."
      flash.keep(:console_alert)
      redirect_to dashboard_path
    end
  end

end
