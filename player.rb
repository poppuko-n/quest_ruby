# frozen_string_literal: true

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
