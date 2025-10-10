module Public::WeeksHelper
  def day_header(date)
    return "" if date.blank?
    "#{date.month}/#{date.day}"
  end
end
