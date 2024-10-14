# ５２枚のカード、変数をもたせる
class Card
    SUITS = ["スペード", "ハート", "ダイアモンド", "クラブ"]
    RANKAS = ["A", "K", "Q", "J", "10", "9", "8", "7", "6", "5", "4", "3", "2"]
    attr_reader :suit, :rank

    def initialize(suit, rank)
        @suit = suit
        @rank = rank
    end

    def name
        return "#{@suit}の#{@rank}です"
    end
end

class Deck
    # カードを作成し、シャッフルを実施
    def initialize
        @cards = []
        Card::SUITS.each do |suit|
            Card::RANKAS.each do |rank|
                @cards << Card.new(suit, rank)
            end
        end
        shuffle
    end

    def shuffle
        @cards.shuffle!
    end

    def to_s
        @cards.map(&:name).join(", ")  # カードの名前をカンマ区切りで返す
    end

    # カードを人数毎（今回は２人）に分ける
    def deal
        @cards.each_slice(@cards.size / 2).to_a
    end
end


# ゲーム進行
class Game
    def initialize
        @deck = Deck.new
        @players = create_players
    end

    def create_players
        @deck.deal.map.with_index do |cards, index|
            Player.new("プレイヤー#{index}", cards)
        end
    end

    def players
        return @players
    end
end

# プレイヤー（２人）の作成
class Player
    attr_reader :name, :hand

    def initialize(name, hand)
        @name = name
        @hand = hand
    end

    def name
        return @name
    end

    def hand
        return @hand
    end
end

game = Game.new
deck = Deck.new
puts game.players[1].hand.map(&:name) 