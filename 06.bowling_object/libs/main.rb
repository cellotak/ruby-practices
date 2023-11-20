# frozen_string_literal: true

require_relative './game'

game = Game.new
symbols = ARGV[0].split(',')

symbols.each do |symbol|
  game.add_shot(symbol)
end

puts game.total_score
