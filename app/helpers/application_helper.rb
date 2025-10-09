module ApplicationHelper
  def holiday_class(date)
    return 'text-primary' if date.saturday?
    return 'text-danger' if date.sunday? || Holidays.on(date, :jp).any?
    nil
  end
end
