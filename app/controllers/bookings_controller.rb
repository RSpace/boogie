class BookingsController < ApplicationController
  before_action :authenticate_user!, :except => :index
  before_action :set_booking, only: [:show]
  authorize_resource

  # GET /bookings
  # GET /bookings.json
  def index
    @bookings = Booking.all_this_month_and_forward
  end

  # GET /bookings/1
  # GET /bookings/1.json
  def show
  end

  # GET /bookings/new
  def new
    @booking_date = params[:date].try(:to_date) rescue nil
    redirect_to bookings_path, notice: 'Vælg venligst den dato du ønsker at booke.' unless @booking_date.present?

    @booking = Booking.new(:booking_date => @booking_date)
  end

  # POST /bookings
  # POST /bookings.json
  def create
    @booking = Booking.new(booking_params.merge(status: 'pending'))

    # Make sure the booking belongs to the current user
    @booking.user = current_user

    # Only start payment process if booking is valid
    if @booking.valid?
      # Get the credit card details submitted by the form
      # token = params[:stripeToken]

      # Create the charge on Stripe's servers - this will charge the user's card
      #   begin
      #     charge = Stripe::Charge.create(
      #       :amount => BOOGIE_SETTINGS[:booking_fee],
      #       :currency => "DKK",
      #       :card => token,
      #       :description => "#{@booking.user.username} #{@booking.booking_date.to_s(:utc)}"
      #     )
      #     @booking.stripe_charge_id = charge.id
      #   rescue Stripe::CardError => e
      #     raise e # TEST
      #     charge = false
      #   end
      # end

      respond_to do |format|
        if @booking.save

          # Update the user's email with what they entered in the Stripe window
          # current_user.update_attribute(:email, charge.source['name']) if charge.source['name'].present?

          # Send confirmation email to the user
          # UserMailer.booking_confirmation(current_user, @booking).deliver

          @stripe_session = Stripe::Checkout::Session.create(
            payment_method_types: ['card'],
            line_items: [{
              name: 'Booking af fælleslokalet',
              description: l(@booking.booking_date, format: BOOGIE_SETTINGS[:date_format]),
              amount: BOOGIE_SETTINGS[:booking_fee],
              currency: 'dkk',
              quantity: 1
            }],
            client_reference_id: @booking.id,
            success_url: booking_url(@booking),
            cancel_url: aborted_bookings_url
          )

          format.json { render json: { booking: @booking, stripe_session_id: @stripe_session.id } }
        else
          format.json { render json: @booking.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  private
  def set_booking
    @booking = Booking.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def booking_params
    params.require(:booking).permit(:booking_date)
  end
end
