# frozen_string_literal: true

require_relative '../libs/shot'

class Frame
  attr_reader :shots, :bonus, :frame_number

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
    @shots[0]&.score == Shot::ALL_PINS
  end

  def spare?
    return false if @shots.size < 2

    @shots[0].score + @shots[1].score == Shot::ALL_PINS && !strike?
  end

  def mark?
    strike? || spare?
  end

  def no_mark?
    !mark?
  end

  def filled?
    if frame_number == LAST_FRAME_NUMBER
      shots.size == 3 || (no_mark? && shots.size == 2)
    else
      strike? || @shots.size == 2
    end
  end

  def score
    bonus_pended? ? nil : shots_sum + bonus
  end

  def shots_sum
    shots.map(&:score).sum
  end
end
