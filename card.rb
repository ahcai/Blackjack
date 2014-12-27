class Card

  attr_accessor :value, :suit

  def initialize(value, suit)
    @value = value
    @suit = suit
  end

  def to_s()
    "#{@value}:#{@suit}"
  end

  def to_i()
    if @value == "A"
      return 1
    elsif ["J","Q","K"].include?(@value)
      return 10
    else
      return @value.to_i
    end
  end

end