class BinsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_bin, only: %i[show edit update destroy]
  before_action :authorize_user, only: %i[show edit update destroy]

  # GET /bins or /bins.json
  def index
    @bins = current_user.bins # Show only bins for the logged-in user
  end

  # GET /bins/delete-bins → Shows a page to select bins for deletion
  def delete_page
    @bins = current_user.bins # List bins that can be deleted
  end

  # GET /bins/1 or /bins/1.json
  def show
    @bin = Bin.find(params[:id])
    @pictures = @bin.pictures # Fetch all pictures for this bin
  end

  # GET /bins/new
  def new
    @bin = current_user.bins.build # Only allow bins associated with the user
  end

  # GET /bins/1/edit
  def edit
  end

  # POST /bins or /bins.json
  def create
    @bin = current_user.bins.build(bin_params)

    respond_to do |format|
      if @bin.save
        format.html { redirect_to @bin, notice: "Bin was successfully created." }
        format.json { render :show, status: :created, location: @bin }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @bin.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /bins/1 or /bins/1.json
  def update
    respond_to do |format|
      if @bin.update(bin_params)
        format.html { redirect_to @bin, notice: "Bin was successfully updated." }
        format.json { render :show, status: :ok, location: @bin }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @bin.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bins/1 or /bins/1.json
  def destroy
    @bin.destroy!

    respond_to do |format|
      format.html { redirect_to bins_path, status: :see_other, notice: "Bin was successfully destroyed." }
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
    params.require(:bin).permit(:name, :location, :category_name) # Fixed params.expect → params.require & permit
  end
end
