# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../libs/main'

class MainTest < Minitest::Test  
  # def test_bowling_case1
  #   ARGV.replace(['6'])
  #   # $stdout = StringIO.new
  #   # out = $stdout.string
  #   assert_equal 6, game.frames[0].shots[0].shot_score
  # end

  def test_check_all_shots_game1
    ARGV.replace(['6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,6,4,5'])
    assert_equal [[6,3],[9,0],[0,3],[8,2],[7,3],[10],[9,1],[8,0],[10],[6,4,5,]], check_all_shots
  end

  def test_check_all_shots_game2
    ARGV.replace(['6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,6,3'])
    assert_equal [[6,3],[9,0],[0,3],[8,2],[7,3],[10],[9,1],[8,0],[10],[6,3]], check_all_shots
  end

end

# ARGV.replace(['6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,6,4,5'])
