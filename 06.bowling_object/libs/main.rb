# frozen_string_literal: true

require_relative './game'

# def input_all_shots(shot_string)
#   game = Game.new
#   shot_chars = shot_string.split(',')
#   shot_chars.each do |shot_char|
#     game.add_shot(shot_char)
#   end
#   game.calc_game_score
# end


game = Game.new

shot_string = ARGV[0]
shot_chars = shot_string.split(',')
shot_chars.each do |shot_char|
  game.add_shot(shot_char)
end

puts game.calc_game_score
