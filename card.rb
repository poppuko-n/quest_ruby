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
    return 14 if @rank == 'ジョーカー'

    RANKS.index(@rank)
  end

  def spade_one?
    @suit == 'スペード' && @rank == 'A'
  end
end
