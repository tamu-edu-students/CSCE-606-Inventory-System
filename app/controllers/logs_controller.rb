class LogsController < ApplicationController
  before_action :authenticate_user!

  def index
    @logs = current_user.logs
    
    if params[:from_date].present? && params[:to_date].present?
      start_date = Date.parse(params[:from_date])
      end_date = Date.parse(params[:to_date])
      @logs = @logs.date_range(start_date, end_date)
    end

    respond_to do |format|
      format.html
      format.json { render json: @logs }
    end
  end
end