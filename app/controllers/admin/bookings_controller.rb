class Admin::BookingsController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin!
  before_action :set_booking, only: [:edit, :update, :destroy]
  authorize_resource
  before_action :load_all_users, only: [:new, :create, :edit, :update]

  # GET /admin/bookings
  # GET /admin/bookings.json
  def index
    @current_year = params['year'].try(:to_i) || Time.now.year
    @bookings = Booking.includes(:user).order(booking_date: :asc)
      .where(booking_date: Date.new(@current_year, 1, 1)..Date.new(@current_year, 12, 31))
  end

  # GET /admin/bookings/new
  def new
    @booking = Booking.new
  end

  # GET /admin/bookings/1/edit
  def edit
  end

  # POST /admin/bookings
  # POST /admin/bookings.json
  def create
    @booking = Booking.new(booking_params)

    respond_to do |format|
      if @booking.save
        format.html { redirect_to admin_bookings_url, notice: 'Bookingen er nu oprettet.' }
        format.json { render :show, status: :created, location: @booking }
      else
        format.html { render :new }
        format.json { render json: @booking.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/bookings/1
  # PATCH/PUT /admin/bookings/1.json
  def update
    respond_to do |format|
      if @booking.update(booking_params)
        format.html { redirect_to admin_bookings_url, notice: 'Bookingen er blevet opdateret.' }
        format.json { render :show, status: :ok, location: @booking }
      else
        format.html { render :edit }
        format.json { render json: @booking.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/bookings/1
  # DELETE /admin/bookings/1.json
  def destroy
    @booking.destroy
    respond_to do |format|
      format.html { redirect_to admin_bookings_url, notice: 'Bookingen er nu slettet.' }
      format.json { head :no_content }
    end
  end

  private
    def set_booking
      @booking = Booking.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def booking_params
      params.require(:booking).permit(:booking_date, :user_id)
    end

    def require_admin!
      # TODO: Figure out how to this check and redirect properly
      redirect_to root_url, notice: 'Du skal være administrator for at tilgå denne del af systemet.' unless current_user.admin?
    end

    def load_all_users
      @all_users = User.all
    end

end
