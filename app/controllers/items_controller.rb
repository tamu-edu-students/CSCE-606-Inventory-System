class ItemsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_item, only: %i[ show edit update destroy ]
  before_action :authorize_item_access, only: %i[show edit update destroy]
  before_action :set_bins_and_locations, only: [:new, :edit]

  # GET /items or /items.json
  def index
    # Get all bins accessible to the user
    user_bins = current_user.bins
    
    # Get bins shared with the user
    shared_bins = Bin.joins(:shared_bins)
                     .where(shared_bins: { shared_with_id: current_user.id })
    
    # Combine user's bins with shared bins
    accessible_bins = (user_bins + shared_bins).uniq
    
    # Get all items from accessible bins
    @items = Item.where(bin_id: accessible_bins.map(&:id))
    
    # Apply search filter if present
    search_query = params[:search] || params[:name]
    if search_query.present?
      @items = @items.where("name LIKE ? OR description LIKE ?", 
                           "%#{search_query}%", 
                           "%#{search_query}%")
    end
    
    # Apply bin filter if present
    if params[:bin_id].present?
      @items = @items.where(bin_id: params[:bin_id])
    end
    
    # Apply sorting
    @items = @items.order(created_at: :desc)
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
    @bins = current_user.accessible_bins
  end

  # GET /items/1/edit
  def edit
    @bins = current_user.accessible_bins
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
      @bins = current_user.accessible_bins
      set_bins_and_locations
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @item.update(item_params)
      redirect_to @item, notice: 'Item was successfully updated.'
    else
      @bins = current_user.accessible_bins
      set_bins_and_locations
      render :edit, status: :unprocessable_entity
    end
  end
  

  # DESTROY
  def destroy
    @item.destroy
    redirect_to items_url, notice: 'Item was successfully deleted.'
  end
  
  # GET /items/suggestions
  def suggestions
    query = params[:query]&.downcase
    return render json: [] if query.blank? || query.length < 2
    
    # Get all bins accessible to the user
    accessible_bins = current_user.bins +
                     Bin.joins(:shared_bins).where(shared_bins: { shared_with_id: current_user.id })
    
    # Find matching items
    all_items = Item.where(bin_id: accessible_bins.map(&:id))
    
    # Filter items by name or description match
    matching_items = all_items.where("LOWER(name) LIKE ? OR LOWER(description) LIKE ?", 
                                   "%#{query}%", 
                                   "%#{query}%")
                            .limit(8)
                            .map do |item|
      { id: item.id, name: item.name, bin_id: item.bin_id, bin_name: item.bin&.name }
    end
    
    render json: matching_items
  end
  
  
  
  

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_item
      @item = Item.find(params[:id])
    end

    def authorize_item_access
      unless @item.accessible_by?(current_user)
        redirect_to items_path, alert: 'You do not have permission to access this item.'
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
        item_pictures: [],
        category_name: [],
        price: [],
        is_shared: []
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
