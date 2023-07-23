class ApplicationController < ActionController::Base
  def booking_fee_by_date(date)
    BOOGIE_SETTINGS[:booking_fee][date.wday]
  end

  helper_method :booking_fee_by_date
end
