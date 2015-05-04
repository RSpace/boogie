class Booking < ActiveRecord::Base

  belongs_to :user

  validates :user, presence: true
  validates :booking_date, presence: true, uniqueness: true

  def self.all_future
    self.where('booking_date > ?', Date.today)
  end

  def self.all_this_month_and_forward
    self.where('booking_date > ?', Date.today.beginning_of_month)
  end

end
