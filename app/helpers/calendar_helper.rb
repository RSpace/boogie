module CalendarHelper
  class CalendarBuilder < TableHelper::TableBuilder
    def td_options(day, id_pattern)
      options = {}
      css_classes = ['slaf']
      css_classes << 'today'    if day.strftime("%Y-%m-%d") ==  @today.strftime("%Y-%m-%d")
      css_classes << 'notmonth' if day.month != @calendar.month
      css_classes << 'weekend'  if day.wday == 0 or day.wday == 6
      css_classes << 'future'   if day > @today.to_date
      options[:class] = css_classes.join(' ') unless css_classes.empty?
      options[:id]    = day.strftime(id_pattern) if id_pattern
      options
    end

  end
end