class LocationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_location, only: %i[show edit update destroy]

  # GET /locations
  def index
    @locations = current_user.locations
  end

  # GET /locations/:id
  def show
  end

  # GET /locations/new
  def new
    @location = current_user.locations.new
  end

  # ✅ **Log movements when locations are created**
  def create
    @location = current_user.locations.new(location_params)
    if @location.save
      log_movement("Created Location", @location)  # ✅ Log location creation
      flash[:notice] = "Location created successfully!"
      redirect_to locations_path
    else
      flash[:alert] = "Failed to create location"
      render :new
    end
  end

  # GET /locations/:id/edit
  def edit
  end

  # ✅ **Log movements when locations are updated**
  def update
    if @location.update(location_params)
      log_movement("Updated Location", @location)  # ✅ Log location update
      flash[:notice] = "Location updated successfully!"
      redirect_to locations_path
    else
      flash[:alert] = "Failed to update location"
      render :edit
    end
  end

  # ✅ **Log movements when locations are deleted**
  def destroy
    location_name = @location.name  # Store name before deletion
    if @location.destroy
      log_movement("Deleted Location", location_name)  # ✅ Log location deletion
      flash[:notice] = "Location deleted successfully!"
      redirect_to locations_path
    else
      flash[:alert] = "Failed to delete location"
      redirect_to locations_path
    end
  end

  private

  def set_location
    @location = current_user.locations.find(params[:id])
  end

  def location_params
    params.require(:location).permit(:name)
  end

  # ✅ **Log Movements in the Session**
  def log_movement(action, location)
    session_record = Session.find_by(id: session[:session_id]) || Session.create(user: current_user, login_time: Time.current)
    session_record.log_movement(action, location)
  end
end
