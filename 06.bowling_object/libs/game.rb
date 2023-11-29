# frozen_string_literal: true

require_relative '../libs/frame'

class Game
  attr_reader :frames

  def initialize
    @frames = []
    @frames << Frame.new(1)
  end

  def add_shot(symbol)
    current_frame.add_shot(symbol)
    update_bonus
    create_next_frame if current_frame.filled? && current_frame.frame_number != Frame::LAST_FRAME_NUMBER
  end

  def current_frame
    frames[-1]
  end

  def previous_frame
    frames[-2]
  end

  def second_previous_frame
    frames[-3]
  end

  def total_score
    frames.sum(&:score)
  end

  private

  def create_next_frame
    frames << Frame.new(current_frame.frame_number + 1)
  end

  def update_bonus
    update_current_frame_bonus
    update_previous_frame_bonus if previous_frame&.bonus_pended?
    update_second_previous_frame_bonus if second_previous_frame&.bonus_pended?
  end

  def update_current_frame_bonus
    current_frame.comfirm_bonus(0) if (current_frame.no_mark? && current_frame.filled?) || current_frame.frame_number == Frame::LAST_FRAME_NUMBER
  end

  def update_previous_frame_bonus
    previous_frame.comfirm_bonus(current_frame.shots_sum) if previous_frame.strike? && current_frame.shots.size == 2
    previous_frame.comfirm_bonus(current_frame.shots[0].score) if previous_frame.spare?
  end

  def update_second_previous_frame_bonus
    second_previous_frame.comfirm_bonus(Shot::ALL_PINS + current_frame.shots[0].score) if previous_frame.strike?
    second_previous_frame.comfirm_bonus(Shot::ALL_PINS) if previous_frame.spare?
  end
end
