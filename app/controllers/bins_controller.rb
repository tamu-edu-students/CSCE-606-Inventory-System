class BinsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_bin, only: %i[show edit update destroy share]
  before_action :authorize_bin_access, only: %i[show edit update destroy share]

  # GET /bins or /bins.json
  def index
    puts "Params: #{params.inspect}"
    @bins = current_user.accessible_bins
    
    # Apply search by name
    @bins = @bins.search_by_name(params[:name]) if params[:name].present?

    # Apply filtering by category
    @bins = @bins.where(category_name: params[:category]) if params[:category].present?

    # Apply filtering by location
    @bins = @bins.where(location_id: params[:location_id]) if params[:location_id].present?

    # Apply sorting by name
    @bins = @bins.order(:name) if params[:sort] == "name"
  end

  # GET /bins/delete-bins → Shows a page to select bins for deletion
  def delete_page
    @bins = current_user.bins # List bins that can be deleted
  end

  # GET /bins/1 or /bins/1.json
  def show
    @bin = Bin.find(params[:id])
  end

  # GET /bins/new
  def new
    @bin = current_user.bins.build
    @locations = current_user.locations  # fetch existing location for dropdown
  end

  # GET /bins/1/edit
  def edit
    @bin = current_user.bins.find(params[:id])
    @locations = current_user.locations
  end

  # POST /bins or /bins.json
  def create
    @bin = current_user.bins.build(bin_params)
    
    # Handle new location creation if no location_id is provided
    if params[:bin][:new_location].present?
      location = current_user.locations.create(name: params[:bin][:new_location])
      @bin.location = location
    end
    
    if @bin.save
      redirect_to @bin, notice: 'Bin was successfully created.'
    else
      @locations = current_user.locations # Ensure dropdown is still populated on error
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /bins/1 or /bins/1.json
  def update
    if @bin.update(bin_params)
      redirect_to @bin, notice: 'Bin was successfully updated.'
    else
      @locations = current_user.locations # Ensure dropdown is still populated on error
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /bins/1 or /bins/1.json
  def destroy
    @bin.destroy
    redirect_to bins_url, notice: 'Bin was successfully deleted.'
  end

  def share
    @friends = current_user.all_friends
    @shared_users = @bin.shared_with_users
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_bin
    @bin = Bin.find(params[:id])
  end

  def authorize_bin_access
    unless @bin.accessible_by?(current_user)
      redirect_to bins_path, alert: 'You do not have permission to access this bin.'
    end
  end

  # Only allow a list of trusted parameters through.
  def bin_params
    params.require(:bin).permit(:name, :location_id, :category_name, :bin_picture)
  end
end
