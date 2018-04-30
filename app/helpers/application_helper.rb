module ApplicationHelper
  def display_dollars(cents)
    dollars = cents / 100.0
    return '%.2f' % dollars
  end

  def display_date(input)
    return input.strftime("%B %d, %Y")
  end

  def display_date_time(input)
    return input.strftime("%m/%d/%Y at %I:%M%p")
  end
end
