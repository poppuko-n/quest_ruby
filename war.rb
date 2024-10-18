# frozen_string_literal: true

# ５２枚のカードをつくり、カードの情報をもたせるクラス
class Card
  SUITS = %w[スペード ハート ダイアモンド クラブ].freeze
  RANKS = %w[A K Q J 10 9 8 7 6 5 4 3 2].freeze
  attr_reader :suit, :rank

  def initialize(suit, rank)
    @suit = suit
    @rank = rank
  end

  # カードの名前
  def name
    "#{@suit}の#{@rank}です。"
  end

  # ランクの強さをかえす。小さい方が強力なカード
  def value
    RANKS.index(@rank)
  end
end

# カードを管理するクラス
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

# プライヤーを管理するクラス
class Player
  attr_reader :name, :hand, :won_cards

  def initialize(name, cards)
    @name = name
    @hand = cards
    @won_cards = []
  end

  # 手札からテーブルに出すカード
  def play_card
    hand.shift
  end

  # 勝者が取った場札を追加
  def collect_won_cards(cards)
    @won_cards.concat(cards)
  end

  # 手札が０枚になった時に場札をシャッフルして加える
  def to_hand
    @hand.concat(@won_cards.shuffle)
    @won_cards.clear
  end

  # プレイヤーの手札が空になっているのか確認
  def empty?
    hand.empty?
  end
end

# ゲーム進行を管理する
class Game
  # シャッフルしたデッキを準備し、各プレイヤーに手札を渡す
  def initialize
    @deck = Deck.new
    @players = create_players
    @table_cards = []
  end

  # 手札を持ったプレイヤーを作成
  def create_players
    @deck.deal.map.with_index do |cards, index|
      Player.new("プレイヤー#{index + 1}", cards)
    end
  end

  # ゲームを開始
  def start
    puts '戦争を開始します。'
    puts 'カードが配られました'
    puts '戦争!'
    buttle until check_gameover     #ゲームオーバになるまでバトルを実施
    display_nohand_player           #手札が０枚になったプレイヤーを表示
    display_hand_size               #各プレイヤーの手札の枚数を表示
    display_ranking                 #ランキングを表示
    puts '戦争を終了します。'
  end

  # バトルを開始する（誰かの手札がなくなるまで実施する作業）
  def buttle
    play_cards = play_around         #場札にカードを出す
    @table_cards.concat(play_cards) 
    displya_play_cards(play_cards)   #場札に出されたカードを表示
    resolve(play_cards)              #判定処理を実施
    manage_empty_players             #手札が0枚になったら山札から手札に追加
  end

  # 各プレイヤーが、場に手札の一番上のカードを場札に出す
  def play_around
    @players.map(&:play_card)
  end

  # 各プレイヤーが場札に出したカードを表示する
  def displya_play_cards(table_cards)
    table_cards.each.with_index do |card, i|
      puts "#{@players[i].name}のカードは#{card.name}"
    end
  end

  # 場札のカードを比較し、勝ち負けの判定を実施する
  def resolve(play_cards)
    values = play_cards.map(&:value)
    if values.uniq.size == 1
      puts '引き分けです。'
    else
      winner_player = values.index(values.min)
      puts "#{@players[winner_player].name}が勝ちました。"
      puts "#{@players[winner_player].name}はカードを#{@table_cards.size}枚もらいました。"
      @players[winner_player].collect_won_cards(@table_cards)
      @table_cards.clear
    end
  end

  # 手札がゼロ枚になった場合は場札を手札へ追加する
  def manage_empty_players
    @players.each do |player|
      player.to_hand if player.empty?
    end
  end

  # 手札が無くなった人が一人でもいればゲーム終了
  def check_gameover
    @players.any?(&:empty?)
  end

  # 手札が無くなったプレイヤーを表示する
  def display_nohand_player
    nohand_players = @players.select { |player| player.hand.empty? }
    nohand_players.each { |nohand_player| puts "#{nohand_player.name}の手札がなくなりました。" }
  end

  # 書くプレイヤの手札の枚数を表示する
  def display_hand_size
    @players.each { |player| puts "#{player.name}の手札の枚数は#{player.hand.size}" }
  end

  # ゲーム終了後、ランキングを表示する
  def display_ranking
    array_ranking = @players.sort_by { |player| -player.hand.size }
    array_ranking.each_with_index do |player, i|
      puts "#{player.name}が#{i + 1}位です。"
    end
  end
end

game = Game.new
game.start
