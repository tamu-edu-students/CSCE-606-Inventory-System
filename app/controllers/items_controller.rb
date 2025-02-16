class ItemsController < ApplicationController
  before_action :require_login
  before_action :set_item, only: %i[ show edit update destroy ]
  before_action :authorize_user, only: [:show, :edit, :update, :destroy]

  # GET /items or /items.json
  def index
    @items = Item.left_joins(:bin)
                 .where('bins.user_id = ? OR items.bin_id IS NULL', current_user.id)
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
  end

  # GET /items/1/edit
  def edit
  end

  # POST /items or /items.json
  # modify to ensure only can create items in bin
  # modify later for standalone items
  def create
    @item = Item.new(item_params)

    # Set no_bin to true if no bin is selected
    @item.no_bin = @item.bin_id.nil?

    if @item.save
      redirect_to items_path, notice: "Item created successfully!"
    else
      @bins = current_user.bins  # Fetch bins again in case of error
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /items/1 or /items/1.json
  def update
    respond_to do |format|
      if @item.update(item_params)
        format.html { redirect_to @item, notice: "Item was successfully updated." }
        format.json { render :show, status: :ok, location: @item }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /items/1 or /items/1.json
  def destroy
    @item.update!(bin_id: nil)
    @item.no_bin = true
    respond_to do |format|
      format.html { 
        redirect_to items_path, 
        status: :see_other, 
        notice: "Item was removed from bin and is now unassigned.", 
        alert: "Warning: This item is not in any bin" 
      }
      format.json { render json: { status: :ok, message: "Item unassigned from bin" } }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_item
      @item = Item.find(params.expect(:id))
    end

    def authorize_user
      if @item.bin.present? && @item.bin.user != current_user
        redirect_to items_path, alert: "Not authorized"
      end
    end
    

    # Only allow a list of trusted parameters through.
    def item_params
      # params.expect(item: [ :name, :description, :created_date, :value, :bin_id ])
      params.require(:item).permit(:name, :value, :bin_id, :no_bin, item_pictures: [])
    end
end
