# frozen_string_literal: true

require_relative '../libs/shot'
require_relative '../libs/bonus'

class Frame
  attr_reader :shots, :bonus, :frame_number

  def initialize
    @shots = []
    # @frame_number = frame_number
  end

  def add_shot(char)
    @shots << Shot.new(char)
  end

  def add_bonus(bonus_score)
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

  def completed?(last_frame_flag: false)
    if last_frame_flag
      if strike? || spare?
        @shots[2]
      else
        @shots[1]
      end
    else
      strike? || @shots[1]
    end
  end
end
