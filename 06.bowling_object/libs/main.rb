# frozen_string_literal: true

require_relative './game'

# ARGV[0]: '6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,6,4,5'

def calc_total_score
  game = Game.new
  shot_chars = ARGV[0].split(',')
  shot_chars.each do |shot_char|
     game.add_shot(shot_char)
  end
  
end

def check_all_shots
  game = Game.new
  shot_chars = ARGV[0].split(',')
  shot_chars.each do |shot_char|
     game.add_shot(shot_char)
  end

  all_frames = []

  game.frames.each do |frame|
    all_shots = []
    frame.shots.each do |shot|
      all_shots << shot.shot_score
    end
    all_frames << all_shots
  end
  all_frames
end


#=> 139
