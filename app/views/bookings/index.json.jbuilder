json.array!(@bookings) do |booking|
  json.extract! booking, :id, :booking_date
  json.url booking_url(booking, format: :json)
end
