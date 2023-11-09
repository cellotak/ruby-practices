require_relative './game'

# ARGV[0]: '6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,6,4,5'
game = Game.new(ARGV[0])
puts game.calc_total_score

#=> 139
