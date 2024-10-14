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

end


# ゲーム進行
class Game
    def prestart
        puts "戦争を開始します"
    end
end

# プレイヤー（２人）の作成
class Player
end

deck = Deck.new
puts deck.to_s
