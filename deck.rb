require './card'

class Deck

  SUITS = ["diamond", "club", "heart", "spade"]
  VALUES = ["2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K", "A"]

  attr_accessor :deck
  attr_reader :SUITS, :VALUES

  def initialize()
    self.reset()
  end

  def reset()
    @deck = []
    for suit in SUITS
      for value in VALUES
        @deck.push(Card.new(value, suit))
      end
    end
    @deck.shuffle!
  end

  def deal()
    if @deck.count <= 0
      self.reset()
    end
    return @deck.pop()
  end

end