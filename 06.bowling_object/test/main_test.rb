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
  def test_game1
    ARGV.replace(['6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,6,4,5'])
    assert_equal 6, main.frames[0].shots[0].shot_score
    assert_equal 3, main.frames[0].shots[1].shot_score
    assert_equal 9, main.frames[1].shots[0].shot_score
    assert_equal 0, main.frames[1].shots[1].shot_score
    assert_equal 0, main.frames[2].shots[0].shot_score
    assert_equal 3, main.frames[2].shots[1].shot_score
    assert_equal 8, main.frames[3].shots[0].shot_score
    assert_equal 2, main.frames[3].shots[1].shot_score
    assert_equal 7, main.frames[4].shots[0].shot_score
    assert_equal 3, main.frames[4].shots[1].shot_score
    assert_equal 10, main.frames[5].shots[0].shot_score
    assert_equal nil, main.frames[5].shots[1]
    assert_equal 9, main.frames[6].shots[0].shot_score
    assert_equal 1, main.frames[6].shots[1].shot_score
    assert_equal 8, main.frames[7].shots[0].shot_score
    assert_equal 0, main.frames[7].shots[1].shot_score
    assert_equal 10, main.frames[8].shots[0].shot_score
    assert_equal nil, main.frames[8].shots[1]
    assert_equal 6, main.frames[9].shots[0].shot_score
    assert_equal 4, main.frames[9].shots[1].shot_score
    assert_equal 5, main.frames[9].shots[2].shot_score
  end

  def test_game2
    ARGV.replace(['6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,6,3'])
    assert_equal 6, main.frames[0].shots[0].shot_score
    assert_equal 3, main.frames[0].shots[1].shot_score
    assert_equal 9, main.frames[1].shots[0].shot_score
    assert_equal 0, main.frames[1].shots[1].shot_score
    assert_equal 0, main.frames[2].shots[0].shot_score
    assert_equal 3, main.frames[2].shots[1].shot_score
    assert_equal 8, main.frames[3].shots[0].shot_score
    assert_equal 2, main.frames[3].shots[1].shot_score
    assert_equal 7, main.frames[4].shots[0].shot_score
    assert_equal 3, main.frames[4].shots[1].shot_score
    assert_equal 10, main.frames[5].shots[0].shot_score
    assert_equal nil, main.frames[5].shots[1]
    assert_equal 9, main.frames[6].shots[0].shot_score
    assert_equal 1, main.frames[6].shots[1].shot_score
    assert_equal 8, main.frames[7].shots[0].shot_score
    assert_equal 0, main.frames[7].shots[1].shot_score
    assert_equal 10, main.frames[8].shots[0].shot_score
    assert_equal nil, main.frames[8].shots[1]
    assert_equal 6, main.frames[9].shots[0].shot_score
    assert_equal 3, main.frames[9].shots[1].shot_score
    assert_equal nil, main.frames[9].shots[2]
  end
end

# ARGV.replace(['6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,6,4,5'])
