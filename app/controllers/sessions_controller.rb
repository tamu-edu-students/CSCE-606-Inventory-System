class SessionsController < Devise::SessionsController
  before_action :redirect_if_authenticated, only: [:new]
  skip_before_action :require_no_authentication, only: [:new]

  def new
    super
  end

  def create
    user = User.find_by(email: params[:user][:email]) # Ensure correct parameter format

    if user && user.valid_password?(params[:user][:password]) # Devise method to check password
      sign_in(:user, user)  # ✅ Fix: Specify the scope

      # ✅ Create a session record for this login with empty movements
      session_record = Session.create(user: user, login_time: Time.current, movements: [])

      # Store session ID in Rails session storage
      session[:session_id] = session_record.id

      # Redirect after sign-in
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
      session_record = Session.find_by(id: session[:session_id])
      if session_record
        session_record.update(logout_time: Time.current)
        session_record.movements << "User logged out"
        session_record.save
      end

      sign_out(current_user)  # ✅ Devise method to log out
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
