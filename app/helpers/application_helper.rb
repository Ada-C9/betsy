module ApplicationHelper
  def display_dollars(cents)
    dollars = cents / 100.0
    return '%.2f' % dollars
  end
end
