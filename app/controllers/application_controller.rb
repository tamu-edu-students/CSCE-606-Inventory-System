class ApplicationController < ActionController::Base
  before_action :debug_session
  before_action :store_location
  before_action :authenticate_user!, except: [:new, :create]
  
  before_action :configure_permitted_parameters, if: :devise_controller?
  
  def after_sign_in_path_for(resource)
    stored_location_for(resource) || dashboard_path
  end

  protected

  # Ensure Devise allows additional parameters like name
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end
  
  # method use in dashboard_controller for login
  #def require_login
  #  unless current_user
  #    store_location # Save URL before redirecting
  #    redirect_to login_path, alert: "You must logged in to access this page"
  #  end
  #end

  private

  # Store the original URL before redirecting to login
  def store_location
    ignored_paths = [new_user_session_path, signup_path,"/password/reset","/password/reset_code","/password","/password/forgot"]
    if request.get? && !request.xhr? && !devise_controller? && !ignored_paths.include?(request.fullpath)
      store_location_for(:user, request.fullpath) 
    end
  end

  def debug_session
    Rails.logger.info "🔵 Session ID: #{session.id}"
    Rails.logger.info "🔵 Session Data: #{session.to_hash}"
    Rails.logger.info "🔵 Current User: #{current_user&.email}"
  end
  
end

