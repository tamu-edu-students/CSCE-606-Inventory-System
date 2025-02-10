class DashboardController < ApplicationController
  before_action :require_login

  #simple for now, only show the username and bins counts 
  def index
    @user = current_user
    @bins_counts = @user.bins.count 
  end
end
