# frozen_string_literal: true

require_relative '../libs/frame'

class Game
  attr_reader :frames

  def initialize
    @frames = []
    @frames << Frame.new(1)
  end

  def add_shot(char)
    if current_frame.completed?
      next_frame_number = frames.size + 1
      frames << Frame.new(next_frame_number)
    end
    current_frame.add_shot(char)
    update_bonus
  end

  def current_frame
    frames.last
  end

  def previous_frame
    frames[-2]
  end

  def second_previous_frame
    frames[-3]
  end

  def update_bonus
    current_frame.comfirm_bonus(0) if current_frame.no_mark? && current_frame.completed?

    if previous_frame&.bonus_pended?
      previous_frame.comfirm_bonus(current_frame.shots.sum(&:shot_score)) if current_frame.shots.size == 2 && previous_frame.strike?
      previous_frame.comfirm_bonus(current_frame.shots[0].shot_score) if previous_frame.spare?
    end

    second_previous_frame.comfirm_bonus(10 + current_frame.shots[0].shot_score) if second_previous_frame&.bonus_pended?
  end
end
