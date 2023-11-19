# frozen_string_literal: true

require_relative '../libs/shot'

class Frame
  attr_reader :shots, :bonus, :frame_number

  def initialize(frame_number)
    @shots = []
    @frame_number = frame_number
  end

  def add_shot(symbol)
    @shots << Shot.new(symbol)
  end

  def comfirm_bonus(bonus)
    @bonus = bonus if @bonus.nil?
  end

  def bonus_pended?
    @bonus.nil?
  end

  def strike?
    @shots[0]&.score == 10
  end

  def spare?
    @shots&.map(&:score)&.sum == 10 && !strike?
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
      shots.map(&:score).sum + bonus
    end
  end
end
