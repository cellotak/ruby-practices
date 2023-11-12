# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../libs/game'

class GameTest < Minitest::Test
  def test_frame_new
    game = Game.new
    assert_equal [], game.frames[0].shots
  end

  def test_add_shot
    game = Game.new
    game.add_shot('1')
    assert_equal 1, game.frames[0].shots[0].shot_score
  end

  def test_add_shot_2times
    game = Game.new
    game.add_shot('1')
    game.add_shot('3')
    assert_equal 1, game.frames[0].shots[0].shot_score
    assert_equal 3, game.frames[0].shots[1].shot_score
    assert_equal [], game.current_frame.shots
  end

  def test_add_shot_strike_and_normal
    game = Game.new
    game.add_shot('X')
    game.add_shot('1')
    assert_equal 10, game.frames[0].shots[0].shot_score
    assert_equal nil, game.frames[0].shots[1].shot_score
    assert_equal 1, game.frames[1].shots[0].shot_score
    assert_equal [], game.current_frame.sho
  end
end
