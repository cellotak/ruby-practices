# frozen_string_literal: true

require_relative './game'

# ARGV[0]: '6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,6,4,5'

def main 
  game = Game.new
  shot_chars = ARGV[0].split(',')
  shot_chars.each do |shot_char|
     game.add_shot(shot_char)
  end
end




#=> 139
