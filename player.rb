require './hand'

class Player

  START_AMOUNT = 1000
  attr_accessor :name, :hands, :money, :bet

  def initialize(name)
    @name = name
    @hands = []
    @money = START_AMOUNT
    @bet = 0
  end

  def set_bet(amount)
    @bet += amount
  end

  def make_bet(amount, hand)
    hand.make_bet(amount)
    @money -= @bet
  end

  def valid_bet(amount)
    return amount > 0 && amount <= @money
  end

  def double_down(hand)
    hand.make_bet(hand.bet)
    @money -= @bet
    @bet += @bet
  end

  def can_double_down()
    return @bet <= @money
  end

  def can_split()
    return @bet <= @money
  end

  def hit(card)
    hand = Hand.new()
    hand.hit(card)
    @hands.push(hand)
  end

  def to_s()
    puts "========PLAYER: #{@name}========"
    puts "Money: #{money}"
    for h in @hands
      h.to_s()
    end
    puts "===============================\n"
  end

end