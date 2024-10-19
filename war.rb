
# frozen_string_literal: true

# カード情報クラス
class Card
  SUITS = %w[スペード ハート ダイアモンド クラブ].freeze
  RANKS = %w[2 3 4 5 6 7 8 9 10 J Q K A].freeze
  attr_reader :suit, :rank

  def initialize(suit, rank)
    @suit = suit
    @rank = rank
  end

  # カードの名前
  def name
    "#{@suit}の#{@rank}です。"
  end

  # カードの強さをかえす。
  def value
    return 14 if @rank == "ジョーカー"
    RANKS.index(@rank)
  end
end

# カード情報を継承し、ジョーカーを作成
class Joker < Card
  def initialize
    super("ジョーカー", "ジョーカー")
  end

  def name
    puts "ジョーカーです。"
  end
end

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

# プレイヤー情報クラス
class Player
  attr_reader :name, :hand, :won_cards

  def initialize(name, hand)
    @name = name
    @hand = hand
    @won_cards = []
  end

  # 手札からテーブルに出すカード
  def play_card
    hand.shift
  end

  # 勝者が取ったカードを場札を追加
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

# ゲーム進行を管理するクラス
class Game
  def initialize
    @deck = Deck.new                     # 山札をシャッフルする
    @players = create_players            # 入力された情報をもとにプレイヤーを作成
    @table_cards = []                    # プレイヤーがテーブルに出す場をセット
    @player_count = 0                    # プレイヤーの人数の初期設定
  end

  # 入力された情報からプレイヤーを作成する
  def create_players
    player_count
    craete_player_object
  end

  # プレイヤーの人数を取得
  def player_count
    puts '戦争を開始します。'
    puts 'プレイヤーの人数を入力してください:'
    @player_count = gets.to_i
  end

  # プレイヤーの情報を取得
  def craete_player_object
    players = []
    (1..@player_count).each do |i|
      puts "プレイヤー#{i}の名前を入力してください:"
      player_name = gets.chomp
      players << player_name
    end
    hands = @deck.each_slice(@deck.size / @player_count).to_a
    players.each_with_index.map do |player, index|
      Player.new(player, hands[index])
    end
  end

  # ゲームを開始
  def start
    puts 'カードが配られました'
    puts '戦争!'
    buttle until check_gameover     # ゲームオーバになるまでバトルを実施
    display_nohand_player           # 手札が０枚になったプレイヤーを表示
    display_hand_size               # 各プレイヤーの手札の枚数を表示
    display_ranking                 # ランキングを表示
    puts '戦争を終了します。'
  end

  # バトルを開始する（誰かの手札がなくなるまで繰り返す作業）
  def buttle
    play_cards = play_around         # 手札の一番上のカードを出す
    @table_cards.concat(play_cards)  # 出されたカードをテーブルの上に並べる、引き分けの場合はどんどん追加される
    displya_play_cards(play_cards)   # 場札に出されたカードを順番に表示
    resolve(play_cards)              # 判定処理を実施
    manage_empty_players             # 手札が0枚になったら山札から手札に追加
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
    max_values_count = values.count(values.max)
    if max_values_count >= 2
      hand_draw
    else
      hand_wineer(values)
    end
  end

  # 引き分け時の処理
  def hand_draw
    puts '引き分けです。'
  end

  # 勝敗がついた時の処理
  def hand_wineer(values)
    winner_player = values.index(values.max)
    puts "#{@players[winner_player].name}が勝ちました。"
    puts "#{@players[winner_player].name}はカードを#{@table_cards.size}枚もらいました。"
    @players[winner_player].collect_won_cards(@table_cards)
    @table_cards.clear
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

  # プレイヤ-の手札の枚数を表示する
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
