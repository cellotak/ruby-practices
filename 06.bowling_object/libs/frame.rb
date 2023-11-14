# frozen_string_literal: true

require_relative '../libs/shot'
require_relative '../libs/bonus'

class Frame
  attr_reader :shots, :bonus, :frame_number

  def initialize(frame_number)
    @shots = []
    @frame_number = frame_number
  end

  def add_shot(char)
    @shots << Shot.new(char)
  end

  def comfirm_bonus(bonus_score)
    @bonus = Bonus.new(bonus_score)
  end

  def bonus_pended?
    @bonus.nil?
  end

  def strike?
    @shots[0]&.shot_score == 10
  end

  def spare?
    @shots&.map(&:shot_score)&.sum == 10 && !strike?
  end

  def no_mark?
    !(strike? || spare?)
  end

  def completed?
    if frame_number == 10
      if strike? || spare?
        @shots[2]
      else
        @shots[1]
      end
    else
      strike? || @shots[1]
    end
  end

  def frame_score
    if bonus_pended?
      nil
    else
      shots.map(&:shot_score).sum + bonus.bonus_score
    end
  end
end
