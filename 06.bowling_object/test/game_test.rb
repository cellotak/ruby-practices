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
  end

  def test_add_shot_strike_and_normal
    game = Game.new
    game.add_shot('X')
    game.add_shot('1')
    assert_equal 10, game.frames[0].shots[0].shot_score
    assert_nil game.frames[0].shots[1]
    assert_equal 1, game.frames[1].shots[0].shot_score
  end

  def test_current_frame
    game = Game.new
    6.times do
      game.add_shot('1')
    end
    assert_equal 3, game.current_frame.frame_number
  end

  def test_previous_frame
    game = Game.new
    6.times do
      game.add_shot('1')
    end
    assert_equal 2, game.previous_frame.frame_number
  end

  def test_second_previous_frame
    game = Game.new
    6.times do
      game.add_shot('1')
    end
    assert_equal 1, game.second_previous_frame.frame_number
  end

  def test_update_bonus1
    game = Game.new
    game.add_shot('1')
    assert_nil game.frames[0].bonus
  end

  def test_update_bonus2
    game = Game.new
    game.add_shot('1')
    game.add_shot('2')
    assert_equal 0, game.frames[0].bonus.bonus_score
  end

  def test_update_bonus3
    game = Game.new
    game.add_shot('X')
    game.add_shot('X')
    game.add_shot('6')
    game.add_shot('4')
    game.add_shot('2')
    game.add_shot('3')
    assert_equal 16, game.frames[0].bonus.bonus_score
    assert_equal 10, game.frames[1].bonus.bonus_score
    assert_equal 2, game.frames[2].bonus.bonus_score
    assert_equal 0, game.frames[3].bonus.bonus_score
  end
end
