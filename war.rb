# frozen_string_literal: true

# ５２枚のカード、変数をもたせる
class Card
  SUITS = %w[スペード ハート ダイアモンド クラブ].freeze
  RANKS = %w[A K Q J 10 9 8 7 6 5 4 3 2].freeze
  attr_reader :suit, :rank

  def initialize(suit, rank)
    @suit = suit
    @rank = rank
  end

  def name
    "#{@suit}の#{@rank}です。"
  end

  def value
    RANKS.index(@rank)
  end
end

# カードを作成し、シャッフルを実施
class Deck
  def initialize
    @cards = []
    Card::SUITS.each do |suit|
      Card::RANKS.each do |rank|
        @cards << Card.new(suit, rank)
      end
    end
    shuffle
  end

  def shuffle
    @cards.shuffle!
  end

  # カードを人数毎（今回は２人）に分けるが、まだ配らない
  def deal
    @cards.each_slice(@cards.size / 2).to_a
  end
end

# プレイヤー（２人）の作成し、分けたカードを手札として渡す
class Player
  attr_reader :name, :hand

  def initialize(name, cards)
    @name = name
    @hand = cards
  end

  def play_card
    hand.shift
  end

  # テーブルのカードを手札に追加
  def add_cards(cards)
    @hand.concat(cards)
  end

  # プレイヤーの手札が空になっているのか確認
  def empty?
    hand.empty?
  end

end

# ゲーム進行
class Game
  # シャッフルしたデッキを準備し、各プレイヤーに手札を渡す
  def initialize
    @deck = Deck.new
    @players = create_players
  end

  # テーブルにカードを置く
  def start
    puts '戦争を開始します。'
    puts 'カードが配られました'
    while @players.none?(&:empty?)
      puts '戦争!'
      buttle
      check_gameover
      end
    end
  end

  # 手札を持ったプレイヤーを作成
  def create_players
    @deck.deal.map.with_index do |cards, index|
      Player.new("プレイヤー#{index + 1}", cards)
    end
  end

  # テーブルに置かれたカードを比較する
  # 引き分けの場合、テーブルにカードをためる
  # 勝者が出るまでカードを出し続ける
  def buttle
    table_cards = []

    loop do
      to_table = @players.map(&:play_card)
      to_table.each.with_index do |card, i|
        puts "#{@players[i].name}のカードは#{card.name}"
        table_cards << card
      end

      values = to_table.map(&:value)
      if values.uniq.size == 1
        puts '引き分けです。'
      else
        winner_player = values.index(values.min)
        puts "#{@players[winner_player].name}が勝ちました。"
        puts "#{@players[winner_player].name}はカードを#{table_cards.size}枚もらいました。"
        @players[winner_player].add_cards(table_cards)
        break
      end
    end
  end


  # 手札が無くなった人が一人でもいればゲーム終了し、プレイヤを表示
  def check_gameover
    @players.each do |player|
      if player.empty?
        puts "#{player.name}の手札がなくなりました。"
      end
  end
end



game = Game.new
game.start
