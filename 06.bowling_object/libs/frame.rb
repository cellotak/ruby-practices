# frozen_string_literal: true

class Frame
  attr_reader :shots, :bonus

  def initialize
    @shots = []
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
    @shots[0].shot_score == 10
  end

  def spare?
    @shots.map(&:shot_score).sum == 10 && !strike?
  end
end
