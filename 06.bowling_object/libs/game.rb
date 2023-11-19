# frozen_string_literal: true

require_relative '../libs/frame'

class Game
  attr_reader :frames

  def initialize
    @frames = []
    @frames << Frame.new(1)
  end

  def add_shot(symbol)
    if current_frame.completed?
      frames << Frame.new(current_frame.frame_number + 1)
    end
    current_frame.add_shot(symbol)
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
    current_frame.comfirm_bonus(0) if (current_frame.no_mark? && current_frame.completed?) || current_frame.frame_number == 10

    if previous_frame&.bonus_pended?
      previous_frame.comfirm_bonus(current_frame.shots.sum(&:score)) if current_frame.shots.size == 2 && previous_frame.strike?
      previous_frame.comfirm_bonus(current_frame.shots[0].score) if previous_frame.spare?
    end

    if second_previous_frame&.bonus_pended?
      second_previous_frame.comfirm_bonus(10 + current_frame.shots[0].score) if previous_frame.strike?
      second_previous_frame.comfirm_bonus(10) if previous_frame.spare?
    end
  end

  def check_all_shot
    all_shots = []
    frames.each do |frame|
      one_frame = []
      frame.shots.each do |shot|
         one_frame << shot.score
      end
      all_shots << one_frame
    end
    all_shots
  end

  def check_all_frame_score
    all_frame_score = []
    frames.each do |frame|
      if frame.frame_score.nil?
        all_frame_score << "#{frame.frame_number}:hoge"
      else
        all_frame_score << "#{frame.frame_number} : #{frame.frame_score}"
      end
    end
    all_frame_score
  end

  def calc_game_score
    game_score = frames.sum do |frame|
      frame.frame_score
    end
    game_score
  end
end
