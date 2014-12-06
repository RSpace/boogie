class Booking < ActiveRecord::Base

  belongs_to :user

  validates_presence_of :user, :booking_date

end
