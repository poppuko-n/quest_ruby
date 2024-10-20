# frozen_string_literal: true

require './card'

# カードを作成、管理するクラス
class Deck
  def initialize
    @cards = []
    Card::SUITS.each do |suit|
      Card::RANKS.each do |rank|
        @cards << Card.new(suit, rank)
      end
    end
    @cards << Joker.new
    shuffle
  end

  def shuffle
    @cards.shuffle!
  end

  def size
    @cards.size
  end

  def each_slice(player_count)
    @cards.each_slice(player_count)
  end
end
