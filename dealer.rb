require './deck'

class Dealer

  attr_accessor :deck, :hand

  def initialize()
    @deck = Deck.new
    @hand = Hand.new("Dealer")
  end

  def deal()
    return @deck.deal()
  end

end