#Alice Cai

#Blackjack game written in Ruby for LiveRamp's coding challenge.
#Assuming that:
# => One 52 card deck is used.
# => No max players.
# => Game ends when all players have lost.

#To run the program, type: ruby blackjack.rb

require './dealer'
require './player'
require './hand'
require './deck'
require './card'

DEBUG = false
#Function for debugging. Change DEBUG to true/false to turn this on/off.
def debug(s)
  if DEBUG
    puts s
  end
end

class Blackjack

  MAX_PLAYERS = 8

  def initialize()
    @dealer = Dealer.new()
    @players = [] #Array of Player objects.
    @player_names = [] #Array of player names; used to check for duplicity.
  end

  #Start, play, and end the game.
  def play_game()
    puts "========BLACKJACK========"

    #Get the number of players.
    puts "How many people will be playing?"
    player_count = gets.chomp.to_i
    while player_count < 1 or player_count > 8
      puts "Number of players must between 1 and 8. How many people will be playing?"
      player_count = gets.chomp.to_i
    end

    #Get names of all the players and store them.
    for player in (1..player_count)
      puts "What is player number #{player}'s name?"
      player_name = gets.chomp
      dup = @player_names.include?(player_name) #Check for duplicate names.
      while player_name.length == 0 or dup
        puts "Invalid name or someone with that name is already playing. Please try again."
        player_name = gets.chomp
        dup = @player_names.include?(player_name) #Check for duplicate names.
      end
      @players.push(Player.new(player_name))
      @player_names.push(player_name)
    end

    puts "Welcome to Blackjack. All players will start out with $1000."

    #Play until all players have lost.
    while @players.length > 0
      play()
    end

    puts "====ALL PLAYERS HAVE LOST===="
  end

  #Play a round.
  def play()
    #Set up the game.
    self.set_up()
    
    #Ask for bets.
    self.make_bets()

    #Hit/stand/double down/split.
    for player in @players
      for hand in player.hands
        hand.to_s()
        while !hand.done
          #If blackjack, break out of loops.
          if hand.is_blackjack
            puts "BLACKJACK"
            puts ""
            hand.stand()
            break
          end

          #Get valid options for player hand.
          options = self.get_options(player, hand)
          puts "#{player.name}, what would you like to do? Please choose one: " + options.join(", ")
          decision = gets.chomp
          while !options.include?(decision)
            puts "Invalid decision. Please choose one: " + options.join(", ")
            decision = gets.chomp
          end

          #Deal with the decision.
          case decision
          when "hit"
            hand.hit(@dealer.deal())
          when "stand"
            hand.stand()
          when "split"
            new_hand = hand.split()
            player.make_bet(player.bet, new_hand)
            player.hands.push(new_hand)
            #If splitting Aces, the hands can only be two-card hands.
            if hand.cards[0].value.include?("A")
              hand.stand()
              new_hand.stand()
            end
            hand.hit(@dealer.deal())
            new_hand.hit(@dealer.deal())
          when "double down"
            player.double_down(hand)
            hand.hit(@dealer.deal())
            hand.stand()
            puts "player money: " + player.money.to_s
          end

          if hand.bust()
            puts "BUSTED"
            #hand.to_s()
            hand.stand()
          end

          hand.to_s()

        end
      end
    end

    #Dealer: hit while hand value < 17. Stand on 16.
    while @dealer.hand.get_value() < 17
      @dealer.hand.hit(@dealer.deal())
    end

    #Determine outcome of round.
    self.get_results()

    #Determine the players that can continue.
    for player in @players
      if player.money <= 0
        puts "#{player.name} is out of money and can no longer play."
        @players -= [player]
      end
    end

    #Reset hands and bets.
    self.clean()
  end

def set_up()
  #Deal two cards to the dealer.
  @dealer.hand.hit(@dealer.deal())
  @dealer.hand.hit(@dealer.deal())

  #Deal two cards to each player.
  for player in @players
    hand = Hand.new(player.name)
    hand.hit(@dealer.deal())
    hand.hit(@dealer.deal())
    player.hands.push(hand)
  end
end

def make_bets()
  for player in @players
    puts "How much money would you like to bet, #{player.name}? Please enter an integer amount."
    amount = gets.chomp.to_i
    is_int = amount.is_a?(Integer)
    while !player.valid_bet(amount) or !is_int
      puts "Invalid amount. Please try again."
      amount = gets.chomp.to_i
      is_int = amount.is_a?(Integer)
    end
    player.set_bet(amount)
    player.make_bet(amount, player.hands[0])
  end
end

def get_options(player, hand)
  options = ["hit", "stand"]
  #Can player split?
  if player.can_split and hand.can_split()
    options.push("split")
  end
  #Can player double down?
  if player.can_double_down
    options.push("double down")
  end
  return options
end

def get_results()
  puts ""
  puts "++++++++RESULTS++++++++"
  puts ""
  @dealer.hand.to_s()
  for player in @players
    hand_count = 1
    for hand in player.hands
      dealer_total = @dealer.hand.get_value()
      hand_total = hand.get_value()
      if (hand.bust() and !@dealer.hand.bust()) or (hand_total < dealer_total and !@dealer.hand.bust())
        puts "#{player.name}'s hand ##{hand_count.to_s} lost to the dealer's!"
      elsif (!hand.bust() and hand_total > dealer_total) or (@dealer.hand.bust() and !hand.bust())
        player.money += hand.bet * 2
        puts "#{player.name}'s hand ##{hand_count.to_s} won against the dealer's!"
      else
        player.money += hand.bet
        puts "#{player.name}'s hand ##{hand_count.to_s} tied against the dealer's!"
      end

      hand_count += 1

    end
  end

  #Print out stats of players.
  puts ""
  for player in @players
    player.to_s
  end
end

def clean()
  @dealer.hand = Hand.new("Dealer")
  for player in @players
    player.bet = 0
    player.hands = []
  end
end

end


blackjack = Blackjack.new
blackjack.play_game()
