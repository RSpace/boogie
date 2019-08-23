class Booking < ActiveRecord::Base
  belongs_to :user

  default_scope { where(status: "confirmed") }

  validates :user, presence: true
  validates :booking_date, presence: true
  validates :booking_date, uniqueness: {scope: :status}, if: :confirmed?
  validates :status, presence: true, inclusion: { in: %w(pending confirmed) }

  def self.all_future
    where('booking_date > ?', Date.today)
  end

  def self.all_this_month_and_forward
    where('booking_date > ?', Date.today.beginning_of_month)
  end

  # See https://stripe.com/docs/api/checkout/sessions/object
  def self.stripe_checkout_session_completed(stripe_obj)
    booking_id = stripe_obj.client_reference_id
    @booking = Booking.unscoped.find_by(id: booking_id, status: 'pending')
    @booking.update_attributes!(
      status: "confirmed",
      stripe_charge_id: stripe_obj.payment_intent
    )
  end

  # See https://stripe.com/docs/api/charges/object
  def self.stripe_charge_suceeded(stripe_obj)
    payment_intent_id = stripe_obj.payment_intent
    @booking = Booking.find_by(stripe_charge_id: payment_intent_id)

    billing_email = stripe_obj.billing_details.email
    @booking.user.update_attributes!(email: billing_email)
    UserMailer.booking_confirmation(@booking.user, @booking).deliver_now
  end

  def pending?
    status == "pending"
  end

  def confirmed?
    status == "confirmed"
  end
end
