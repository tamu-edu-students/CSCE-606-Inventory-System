class LocationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_location, only: [:show, :edit, :update, :destroy]

  # GET /locations
  def index
    @locations = current_user.locations
    @location = Location.new
    if params[:name].present?
      @locations = @locations.where("LOWER(name) LIKE ?", "%#{params[:name].downcase}%")
    end

    if request.xhr?
      render partial: "locations_table", locals: { locations: @locations }, layout: false
    else
      render :index
    end
  end

  def new
    @location = current_user.locations.build
  end

  # POST /locations
  def create
    @location = current_user.locations.build(location_params)
    if @location.save
      redirect_to bins_path, notice: 'Location was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  # PATCH/PUT /locations/:id
  def update
    if @location.update(location_params)
      redirect_to bins_path, notice: 'Location was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /locations/:id
  def destroy
    @location.destroy
    redirect_to bins_path, notice: 'Location was successfully deleted.'
  end

  private

  def set_location
    @location = current_user.locations.find(params[:id])
  end

  def location_params
    params.require(:location).permit(:name, :description)
  end
end
