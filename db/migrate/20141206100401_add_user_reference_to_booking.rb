class AddUserReferenceToBooking < ActiveRecord::Migration
  def change
    add_reference :bookings, :user, index: true, null: false
  end
end
