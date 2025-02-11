class BinsController < ApplicationController
  before_action :require_login
  before_action :set_bin, only: %i[ show edit update destroy ]
  before_action :authorize_user, only: [:show, :edit, :update, :destroy]

  # GET /bins or /bins.json
  def index
    @bins = current_user.bins #only current bin for login users
  end

  # GET /bins/1 or /bins/1.json
  def show
    @bin = Bin.find(params[:id])
  end

  # GET /bins/new
  def new
    @bin = current_user.bins.build # only for bin associated with user
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
      @bin = Bin.find(params.expect(:id))
    end

    def authorize_user
      redirect_to bins_path, alert: "Not authorized" if @bin.user != current_user
    end

    # Only allow a list of trusted parameters through.
    def bin_params
      params.expect(bin: [ :name, :location, :category_name ])
    end
end
