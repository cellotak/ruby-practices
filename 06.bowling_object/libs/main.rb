# frozen_string_literal: true

require_relative './game'

# def input_all_shots(shot_string)
#   game = Game.new
#   shot_symbols = shot_string.split(',')
#   shot_symbols.each do |shot_symbol|
#     game.add_shot(shot_symbol)
#   end
#   game.calc_game_score
# end


game = Game.new

shot_string = ARGV[0]
shot_symbols = shot_string.split(',')
shot_symbols.each do |shot_symbol|
  game.add_shot(shot_symbol)
end

puts game.calc_game_score
