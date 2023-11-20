# frozen_string_literal: true

require_relative './game'

game = Game.new
shot_symbols = ARGV[0].split(',')

shot_symbols.each do |shot_symbol|
  game.add_shot(shot_symbol)
end

puts game.calc_game_score
