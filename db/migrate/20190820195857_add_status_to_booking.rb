class AddStatusToBooking < ActiveRecord::Migration
  def change
    add_column :bookings, :status, :string, null: false, default: "confirmed"
  end
end
