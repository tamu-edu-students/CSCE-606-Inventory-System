class ItemsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_item, only: %i[show edit update destroy]
  before_action :authorize_user, only: %i[show edit update destroy]

  # GET /items or /items.json
  def index
    @items = Item.left_joins(:bin)
                 .where('bins.user_id = ? OR items.bin_id IS NULL', current_user.id)
  end

  # GET /items/1 or /items/1.json
  def show
    @bins = Bin.where(user_id: current_user.id) # List all possible bins for the item
  end

  # GET /items/new
  def new
    @item = Item.new
    @bins = current_user.bins
  end

  # GET /items/1/edit
  def edit
    @bins = current_user.bins  # Ensure bins are available for selection
  end

  # ✅ **Log movements when items are created**
  def create
    @item = Item.new(item_params)
    @item.no_bin = @item.bin_id.nil?  # Set no_bin flag

    if @item.save
      log_movement("Created Item", @item)  # ✅ Log item creation
      flash[:notice] = "Item was successfully created"
      redirect_to items_path
    else
      @bins = current_user.bins
      render :new, status: :unprocessable_entity
    end
  end

  # ✅ **Log movements when items are updated**
  def update
    if @item.update(item_params)
      log_movement("Updated Item", @item)  # ✅ Log item update
      redirect_to @item, notice: "Item was successfully updated."
    else
      @bins = current_user.bins
      render :edit, status: :unprocessable_entity
    end
  end

  # ✅ **Log movements when items are deleted**
  def destroy
    item_name = @item.name  # Store item name before deletion
    if @item.destroy
      log_movement("Deleted Item", item_name)  # ✅ Log item deletion
      redirect_to items_path, status: :see_other, notice: "Item was successfully removed."
    else
      redirect_to items_path, alert: "Failed to delete item."
    end
  end

  private

  def set_item
    @item = Item.find(params[:id])
  end

  def authorize_user
    if @item.bin.present? && @item.bin.user != current_user
      redirect_to items_path, alert: "Not authorized"
    end
  end

  def item_params
    params.require(:item).permit(:name, :description, :value, :bin_id, :no_bin, item_pictures: [])
  end

  # ✅ **Log Movements in the Session**
  def log_movement(action, item)
    session_record = Session.find_by(id: session[:session_id]) || Session.create(user: current_user, login_time: Time.current)
    session_record.log_movement(action, item)
  end
end
