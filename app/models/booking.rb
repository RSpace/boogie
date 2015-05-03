class Booking < ActiveRecord::Base

  belongs_to :user

  validates_presence_of :user, :booking_date

  def self.all_future
    self.where('booking_date > ?', Date.today)
  end

end
