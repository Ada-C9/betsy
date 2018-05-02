class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  private

  # Returns 'true' if provided input is a String that is not blank. Otherwise,
  # returns 'false'.
  def self.is_non_empty_string?(input)
    input.squish! if input.is_a?(String)
    return input.is_a?(String) && !input.blank?
  end

end

# Does this actually work? It's not in a class - Kirsten
def show_date
  return self.strftime("%m/%d/%Y")
end

################################################################################
class Integer

  # PRE: integer must represent a value in cents, and this method should not be
  # called unless no additional calculations are expected to be done.
  #
  # Returns the dollars equivalent of integer cents as a String with two decimal
  # places.
  def cents_to_dollars
    return "$#{'%.2f' % (self / 100.0)}"
  end

end

################################################################################
class Date

  # Provided int_month and int_year must be int_year.
  def self.is_in_the_future?(int_month, int_year)
    return if !int_month.is_a?(Integer) || !int_month.between?(1,12) ||
      !int_year.is_a?(Integer)
    return check_if_in_the_future(int_month, int_year)
  end

  private

  def self.check_if_in_the_future(int_month, int_year)
    return (int_month >= self.today.month && int_year >= self.today.year) ||
     int_year > self.today.year
  end
end

################################################################################
class String
  def has_only_n_digits?(n)
    raise ArgumentError.new("'n' must be int > 0") if !n.is_a?(Integer) && n < 0
    return length == n && !self.match(/[\D]/)
  end

end
