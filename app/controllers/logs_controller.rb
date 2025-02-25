class LogsController < ApplicationController
  before_action :authenticate_user!

  def index
    @sessions = current_user.sessions.order(login_time: :desc)
  end
end
