class PicturesController < ApplicationController
  before_action :find_parent, only: [ :new, :create, :destroy ]

  def new
    @picture = @parent.pictures.build(user: current_user)
  end

  def create
    @picture = @parent.pictures.build(picture_params)
    @picture.user = current_user

    # ✅ Ensure every picture has a `bin_id`
    @picture.bin_id = @parent.is_a?(Bin) ? @parent.id : @parent.bin_id

    # ✅ If it's a bin picture, `item_id` should be NULL
    @picture.item_id = @parent.is_a?(Item) ? @parent.id : nil

    if @picture.save
      redirect_to @parent, notice: "Picture uploaded successfully!"
    else
      render :new
    end
  end


  def destroy
    @picture = @parent.pictures.find(params[:id])
    @picture.destroy
    redirect_to @parent, notice: "Picture deleted."
  end

  private

  def picture_params
    params.require(:picture).permit(:image)
  end

  def find_parent
    if params[:bin_id].present?
      @parent = Bin.find(params[:bin_id])  # ✅ Finds the Bin if bin_id is present
    elsif params[:item_id].present?
      @parent = Item.find(params[:item_id])  # ✅ Finds the Item if item_id is present
    else
      redirect_to root_path, alert: "Invalid request."
    end
  end
end
