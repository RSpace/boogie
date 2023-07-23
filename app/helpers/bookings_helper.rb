module BookingsHelper
  def for_each_future_month(month_count)

    now = Time.now
    year = now.year
    month = now.month

    month_count.times do
      yield(year, month)

      month += 1
      if month > 12
        year += 1
        month = 1
      end
    end
  end
end
