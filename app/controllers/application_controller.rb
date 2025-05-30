class ApplicationController < ActionController::Base
  def booking_fee_by_date(date)
    BOOGIE_SETTINGS[:booking_fee][date.wday]
  end

  helper_method :booking_fee_by_date

  protected
  def require_admin!
    # TODO: Figure out how to this check and redirect properly
    redirect_to root_url, notice: 'Du skal være administrator for at tilgå denne del af systemet.' unless current_user.admin?
  end
end
