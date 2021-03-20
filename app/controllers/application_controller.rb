class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def booking_fee_by_date(date)
    BOOGIE_SETTINGS[:booking_fee][date.wday]
  end

  helper_method :booking_fee_by_date
end
