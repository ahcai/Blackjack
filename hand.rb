require './card'
require './deck'
require './dealer'

class Hand

  attr_accessor :player, :cards, :bet, :done

  def initialize(player)
    @player = player
    @cards = []
    @bet = 0
    @done = false
  end

  def make_bet(amount)
    @bet += amount
  end

  def hit(card)
    @cards.push(card)
  end

  def stand()
    @done = true
  end

  def bust()
    return self.get_value() > 21
  end

  def get_value()
    total = 0
    @cards.each do |c|
      total += c.to_i()
    end

    #Deal with Ace.
    ace = false
    @cards.each do |c|
      if c.value == "A"
        ace = true
      end
    end

    if ace and total+10 <= 21
      total += 10
    end

    return total
  end

  def split()
    #Returns the new hand.
    new_hand = Hand.new(@player)
    new_hand.cards.push(@cards.pop())
    return new_hand
  end

  def can_split()
    #Can split only if there are two cards in the hand, and both cards have the same face value.
    if @cards.length == 2
      if ["J","Q","K"].include?(@cards[0].value) and ["J","Q","K"].include?(@cards[1].value)
        return true
      end
      return @cards[0].value == @cards[1].value
    end
    return false
  end

  def is_blackjack()
    if self.get_value() == 21
      return true
    else
      return false
    end
  end

  def to_s()
    puts "--------#{@player}'s hand--------"
    puts @cards.join(', ')
    puts "Bet: " + @bet.to_s
    puts "Total value: " + get_value.to_s
    puts "---------------------------------\n"
    puts ""
  end

end