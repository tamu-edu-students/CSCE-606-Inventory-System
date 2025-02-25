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
  end

  # GET /bins/new
  def new
    @bin = current_user.bins.build # Only allow bins associated with the user
  end

  # GET /bins/1/edit
  def edit
  end

  # ✅ **Log movements when bins are created**
  def create
    @bin = current_user.bins.build(bin_params)

    respond_to do |format|
      if @bin.save
        log_movement("Created Bin", @bin)  # ✅ Log bin creation
        format.html { redirect_to @bin, notice: "Bin was successfully created." }
        format.json { render :show, status: :created, location: @bin }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @bin.errors, status: :unprocessable_entity }
      end
    end
  end

  # ✅ **Log movements when bins are updated**
  def update
    respond_to do |format|
      if @bin.update(bin_params)
        log_movement("Updated Bin", @bin)  # ✅ Log bin update
        format.html { redirect_to @bin, notice: "Bin was successfully updated." }
        format.json { render :show, status: :ok, location: @bin }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @bin.errors, status: :unprocessable_entity }
      end
    end
  end

  # ✅ **Log movements when bins are deleted**
  def destroy
    bin_name = @bin.name  # Store bin name before deletion
    if @bin.destroy
      log_movement("Deleted Bin", @bin)  # ✅ Log bin deletion
      redirect_to bins_path, status: :see_other, notice: "Bin was successfully destroyed."
    else
      redirect_to bins_path, alert: "Failed to delete bin."
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_bin
    @bin = Bin.find(params[:id])
  end

  def authorize_user
    redirect_to bins_path, alert: "Not authorized" if @bin.user != current_user
  end

  def bin_params
    params.require(:bin).permit(:name, :location, :category_name)
  end

  # ✅ **Log Movements in the Session**
  def log_movement(action, bin)
    session_record = Session.find_by(id: session[:session_id]) || Session.create(user: current_user, login_time: Time.current)
    session_record.log_movement(action, bin)
  end
end
