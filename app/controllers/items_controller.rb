class ItemsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_item, only: %i[ show edit update destroy ]
  before_action :authorize_user, only: [:show, :edit, :update, :destroy]

  # GET /items or /items.json
  def index
    if params[:location_id]
      @items = current_user.items.where(location_id: params[:location_id])
    else
      @items = current_user.items # Show only items for the logged-in user
    end

    # Filter by for_sale status if provided
    if params[:for_sale].present?
      @items = @items.for_sale
    end
    
    # Filter by sale date if provided
    if params[:sale_date].present?
      @items = @items.where("created_at <= ?", params[:sale_date])
    end
    
    # Apply search filtering if a name is provided
    @items = @items.search_by_name(params[:name])
  end

  # GET /items/1 or /items/1.json
  def show
    # list all possible bins for the item
    @bins = Bin.where(user_id: current_user.id)
  end

  # GET /items/new
  def new
    @item = Item.new
    @bins = current_user.bins
    @item.bin_id = params[:bin_id] if params[:bin_id].present? # for new items on bin page
    @locations = current_user.locations
    @bin_location_map = @bins.includes(:location).map { |b| [b.id, b.location_id] }.to_h
  end

  # GET /items/1/edit
  def edit
    @bins = current_user.bins  # Add this line to set @bins and have bin available for dropdown menu
    @locations = current_user.locations
    @bin_location_map = @bins.includes(:location).map { |b| [b.id.to_s, b.location_id] }.to_h
  end

  # POST /items or /items.json
  # modify to ensure only can create items in bin
  # modify later for standalone items
  def create
    @item = current_user.items.build(item_params) 

    # Set no_bin to true if no bin is selected
    @item.no_bin = @item.bin_id.nil?

     # Set the item's location:
    if @item.bin_id.present?
      # If a bin is selected, inherit the location from the bin
      @item.location_id = Bin.find(@item.bin_id).location_id
    else
      #let hte user summited the location id
    end

    if @item.save
      if params[:bin_id].present?
        flash[:notice] = "Item added to bin." 
        redirect_to bin_path(params[:bin_id])
      else
        flash[:notice] = "Item was successfully created"  # ✅ Ensure this is set
        redirect_to items_path
      end
    else
      @bins = current_user.bins  # Fetch bins again in case of error
      @locations = current_user.locations
      render :new, status: :unprocessable_entity
    end
  end

  def update
    pp params[:item]
  
    respond_to do |format|
      if @item.update(item_params)
        # Set no_bin flag
        if params[:item][:bin_id].blank?
          @item.update(no_bin: true)
        else
          @item.update(no_bin: false)
  
          # Inherit location from bin if bin is selected
          bin = Bin.find_by(id: @item.bin_id)
          @item.update(location_id: bin.location_id) if bin&.location_id
        end
  
        format.html { redirect_to @item, notice: "Item was successfully updated." }
        format.json { render :show, status: :ok, location: @item }
      else
        @bins = current_user.bins
        @locations = current_user.locations
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end
  

  # DESTROY
  def destroy
    if @item.safe_destroy
      flash[:notice] = "Item deleted"
    else
      flash[:alert] = "Item was unassigned, click delete again to permanently delete it"
    end

    if params[:bin_id].present?
      redirect_to bin_path(params[:bin_id])
    else
      redirect_to items_path
    end
  end
  
  
  
  

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_item
      @item = Item.find(params[:id])
    end

    def authorize_user
      if @item.bin.present? && @item.bin.user != current_user
        redirect_to items_path, alert: "Not authorized"
      end
    end
    
    
    def item_params
      permitted = params.require(:item).permit(
        :name,
        :description,
        :value,
        :bin_id,
        :no_bin,
        :location_id,
        :for_sale,
        item_pictures: []
      )
    
      if permitted[:item_pictures]&.all?(&:blank?)
        permitted.delete(:item_pictures)
      end
    
      permitted
    end
    
end
