Stripe.api_key             = ENV['STRIPE_SECRET_KEY']
Stripe.api_version         = "2019-08-14"
StripeEvent.signing_secret = ENV['STRIPE_SIGNING_SECRET']

StripeEvent.configure do |events|
  events.subscribe 'checkout.session.completed' do |event|
    Booking.stripe_checkout_session_completed(event.data.object)
  end
end
