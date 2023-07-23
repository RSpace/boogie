class UserMailer < ActionMailer::Base
  default from: "skrum@valby-have.dk"

  def booking_confirmation(user, booking)
    @user = user
    @booking = booking
    mail(to: user.email, subject: "Kvittering for booking af fællesrummet")
  end
end
