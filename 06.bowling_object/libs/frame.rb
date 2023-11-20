# frozen_string_literal: true

require_relative '../libs/shot'

class Frame
  attr_reader :shots, :bonus, :frame_number

  ALL_PINS = 10
  LAST_FRAME_NUMBER = 10

  def initialize(frame_number)
    @shots = []
    @frame_number = frame_number
  end

  def add_shot(symbol)
    @shots << Shot.new(symbol)
  end

  def comfirm_bonus(bonus)
    @bonus = bonus if bonus_pended?
  end

  # @bonusがnilということは保留中であるということを明示的にしたい
  def bonus_pended?
    @bonus.nil?
  end

  # 第1フレームの1投目の直前のみshots[0]がnilとなるのでぼっち演算子で対応
  def strike?
    @shots[0]&.score == ALL_PINS
  end

  def spare?
    shots_sum == ALL_PINS && !strike?
  end

  def no_mark?
    !(strike? || spare?)
  end

  def filled?
    if frame_number == LAST_FRAME_NUMBER
      (strike? || spare?) ? @shots[2] : @shots[1]
    else
      strike? || @shots[1]
    end
  end

  def frame_score
    bonus_pended? ? nil : shots_sum + bonus
  end

  def shots_sum
    shots.map(&:score).sum
  end
end
