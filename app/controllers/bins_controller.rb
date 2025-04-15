class BinsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_bin, only: %i[show edit update destroy share update_sharing]
  before_action :authorize_bin_access, only: %i[show]
  before_action :authorize_bin_edit, only: %i[edit update destroy share update_sharing]

  # GET /bins or /bins.json
  def index
    # Start with the base query for current user's bins
    @bins = current_user.bins.includes(:location)
    
    # Also include bins shared with the current user
    shared_bins = Bin.joins(:shared_bins)
                     .where(shared_bins: { shared_with_id: current_user.id })
                     .includes(:location)
    
    # Combine user's bins with shared bins
    @bins = (@bins + shared_bins).uniq
    
    # Apply search by name or category
    search_query = params[:search] || params[:name]
    if search_query.present?
      search_query = search_query.downcase
      @bins = @bins.select do |bin| 
        bin.name.downcase.include?(search_query) || 
        (bin.category_name && bin.category_name.downcase.include?(search_query))
      end
    end

    # Apply filtering by category (exact match)
    if params[:category].present?
      category = params[:category].strip
      @bins = @bins.select { |bin| bin.category_name == category }
    end

    # Sort bins by created_at descending
    @bins = @bins.sort_by { |bin| bin.created_at }.reverse
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

  # POST /bins/1/share
  def update_sharing
    unless @bin.is_shared
      redirect_to edit_bin_path(@bin), alert: 'To share this bin with friends, please enable the "Allow sharing with friends" option in the bin settings.'
      return
    end

    # Remove all existing shares
    @bin.shared_bins.destroy_all
    
    # Add new shares
    if params[:shared_with_ids].present?
      params[:shared_with_ids].each do |user_id|
        SharedBin.create(bin: @bin, shared_with_id: user_id)
      end
    end
    
    redirect_to @bin, notice: 'Bin sharing updated successfully.'
  end

  # GET /bins/suggestions
  def suggestions
    query = params[:query]&.downcase
    return render json: [] if query.blank? || query.length < 2
    
    # Get user's own bins and shared bins
    user_bins = current_user.bins
    shared_bins = Bin.joins(:shared_bins)
                     .where(shared_bins: { shared_with_id: current_user.id })
    all_bins = (user_bins + shared_bins).uniq
    
    # Filter bins by name match
    matching_bins = all_bins.select do |bin|
      bin.name.downcase.include?(query)
    end.first(5).map do |bin|
      { id: bin.id, name: bin.name, type: 'bin' }
    end
    
    # Find matching categories
    all_categories = all_bins.map(&:category_name).compact.uniq
    matching_categories = all_categories.select do |category|
      category.downcase.include?(query)
    end.first(3).map do |category|
      { id: nil, name: category, type: 'category' }
    end
    
    # Combine results
    suggestions = (matching_bins + matching_categories).first(8)
    
    render json: suggestions
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

  def authorize_bin_edit
    unless @bin.user == current_user
      redirect_to bins_path, alert: 'You can only edit your own bins.'
    end
  end

  # Only allow a list of trusted parameters through.
  def bin_params
    params.require(:bin).permit(:name, :location_id, :category_name, :bin_picture, :is_shared)
  end
end
