class BinsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_bin, only: %i[show edit update destroy]
  before_action :authorize_user, only: %i[show edit update destroy]

  # GET /bins or /bins.json
  def index
    puts "Params: #{params.inspect}"
    @bins = current_user.bins
    @bins = @bins.search_by_name(params[:name]) # ✅ Keeps user filtering + adds search

    # Apply filtering by category
    @bins = @bins.where(category_name: params[:category]) if params[:category].present?

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
    @bin = current_user.bins.build(bin_params.except(:location_id, :new_location))
    # @bin = current_user.bins.build(bin_params.except(:location)) # Exclude location from direct params
    # @bin.location = Location.find_by(name: bin_params[:location]) # Find the Location object
    # Use existing location if selected
    if bin_params[:location_id].present?
      @bin.location = Location.find_by(id: bin_params[:location_id])
    elsif bin_params[:new_location].present?
      # Create a new location if none is selected
      @bin.location = current_user.locations.create(name: bin_params[:new_location])
    end

    respond_to do |format|
      if @bin.save
        format.html { redirect_to @bin, notice: "Bin was successfully created." }
        format.json { render :show, status: :created, location: @bin }
      else
        @locations = current_user.locations # Ensure dropdown is still populated on error
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @bin.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /bins/1 or /bins/1.json
  def update
    respond_to do |format|
      # Remove location_id and new_location before updating other attributes
      if @bin.update(bin_params.except(:location_id, :new_location))

        # Handle location update logic
        if bin_params[:location_id].present?
          @bin.location = Location.find_by(id: bin_params[:location_id])
        elsif bin_params[:new_location].present?
          @bin.location = current_user.locations.create(name: bin_params[:new_location])
        end

        @bin.save # Save location changes

        format.html { redirect_to @bin, notice: "Bin was successfully updated." }
        format.json { render :show, status: :ok, location: @bin }
      else
        @locations = current_user.locations # Ensure dropdown is still populated on error
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @bin.errors, status: :unprocessable_entity }
      end
    end
  end


  # DELETE /bins/1 or /bins/1.json
  def destroy
    @bin.destroy!

    respond_to do |format|
      format.html { redirect_to bins_path, status: :see_other, notice: "Bin was successfully destroyed. The items Inside were Unassigned" }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_bin
    @bin = Bin.find(params[:id]) # Fixed issue: params.expect → params[:id]
  end

  def authorize_user
    redirect_to bins_path, alert: "Not authorized" if @bin.user != current_user
  end

  # Only allow a list of trusted parameters through.
  def bin_params
    params.require(:bin).permit(:name, :location, :category_name, :bin_picture, :location_id, :new_location) # Fixed params.expect → params.require & permit
  end
end
