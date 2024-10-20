# frozen_string_literal: true

require './card'

# カード情報を継承し、ジョーカーを作成
class Joker < Card
  def initialize
    super('ジョーカー', 'ジョーカー')
  end

  def name
    'ジョーカーです。'
  end
end
