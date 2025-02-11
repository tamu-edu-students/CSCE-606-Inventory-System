class ItemsController < ApplicationController
  before_action :require_login
  before_action :set_item, only: %i[ show edit update destroy ]
  before_action :authorize_user, only: [:show, :edit, :update, :destroy]

  # GET /items or /items.json
  def index
    @items = Item.joins(:bin).where(bins: { user_id: current_user.id }) # Only show items from user's bins
  end

  # GET /items/1 or /items/1.json
  def show
  end

  # GET /items/new
  def new
    @item = Item.new
  end

  # GET /items/1/edit
  def edit
  end

  # POST /items or /items.json
  # modify to ensure only can create items in bin
  # modify later for standalone items
  def create
    @bin = current_user.bins.find_by(id: item_params[:bin_id]) # Ensure bin belongs to the user

    if @bin.nil?
      redirect_to items_path, alert: "invalid bin selection" and return
    end

    @item = @bin.items.build(item_params)


    respond_to do |format|
      if @item.save
        format.html { redirect_to @item, notice: "Item was successfully created." }
        format.json { render :show, status: :created, location: @item }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
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
    @item.destroy!

    respond_to do |format|
      format.html { redirect_to items_path, status: :see_other, notice: "Item was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_item
      @item = Item.find(params.expect(:id))
    end

    def authorize_user
      redirect_to items_path, alert: "Not authorized" if @item.bin.user != current_user
    end

    # Only allow a list of trusted parameters through.
    def item_params
      params.expect(item: [ :name, :description, :created_date, :value, :bin_id ])
    end
end
