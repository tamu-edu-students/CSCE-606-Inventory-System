class ItemsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_item, only: %i[ show edit update destroy ]
  before_action :authorize_user, only: [:show, :edit, :update, :destroy]
  before_action :set_bins_and_locations, only: [:new, :edit]

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

  def log
    @start_date = params[:start_date] ? Date.parse(params[:start_date]) : Date.today.beginning_of_month
    @end_date = params[:end_date] ? Date.parse(params[:end_date]) : Date.today

    @items = current_user.items
      .where(created_at: @start_date.beginning_of_day..@end_date.end_of_day)
      .order(created_at: :desc)
  end

  # GET /items/1 or /items/1.json
  def show
    # list all possible bins for the item
    @bins = Bin.where(user_id: current_user.id)
  end

  # GET /items/new
  def new
    @item = current_user.items.build
  end

  # GET /items/1/edit
  def edit
    @bins = current_user.bins  # Add this line to set @bins and have bin available for dropdown menu
    @locations = current_user.locations
  end

  # POST /items or /items.json
  def create
    @item = current_user.items.build(item_params)
    
    # Set no_bin flag based on whether a bin is selected
    @item.no_bin = @item.bin_id.blank?
    
    if @item.save
      redirect_to @item, notice: 'Item was successfully created.'
    else
      set_bins_and_locations
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @item.update(item_params)
      redirect_to @item, notice: 'Item was successfully updated.'
    else
      set_bins_and_locations
      render :edit, status: :unprocessable_entity
    end
  end
  

  # DESTROY
  def destroy
    @item.destroy
    redirect_to items_url, notice: 'Item was successfully deleted.'
  end
  
  
  
  

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_item
      @item = current_user.items.find(params[:id])
    end

    def authorize_user
      if @item.bin.present? && @item.bin.user != current_user
        redirect_to items_path, alert: "Not authorized"
      end
    end
    
    def set_bins_and_locations
      @bins = current_user.bins
      @locations = current_user.locations
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
    
    def generate_log_text(items, start_date, end_date)
      text = []
      text << "Inventory Log Report"
      text << "Generated on: #{Time.current.strftime('%B %d, %Y at %I:%M %p')}"
      text << "Date Range: #{start_date.strftime('%B %d, %Y')} to #{end_date.strftime('%B %d, %Y')}"
      text << "Total Items: #{items.count}"
      text << "Total Value: #{number_to_currency(items.sum(:value))}"
      text << "\n"

      items.each do |item|
        text << "Item: #{item.name}"
        text << "Description: #{item.description}"
        text << "Value: #{number_to_currency(item.value)}"
        text << "Created: #{item.created_at.strftime('%B %d, %Y at %I:%M %p')}"
        text << "Bin: #{item.bin&.name || 'No bin'}"
        text << "Status: #{item.for_sale ? 'For Sale' : 'Not for Sale'}"
        text << "-" * 50
      end

      text.join("\n")
    end
end
