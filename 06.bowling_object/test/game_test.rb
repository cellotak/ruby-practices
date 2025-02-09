# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../libs/game'

class GameTest < Minitest::Test
  # initializeでframeが正しく初期化できているか
  def test_game_initialize
    game = Game.new
    assert_equal [], game.frames[0].shots
  end

  # add_shotのテスト
  def test_add_shot
    game = Game.new
    game.add_shot('1')
    assert_equal 1, game.frames[0].shots[0].score
  end

  def test_add_shot_2times
    game = Game.new
    game.add_shot('1')
    game.add_shot('3')
    assert_equal 1, game.frames[0].shots[0].score
    assert_equal 3, game.frames[0].shots[1].score
  end

  def test_add_shot_strike_and_no_mark
    game = Game.new
    game.add_shot('X')
    game.add_shot('1')
    assert_equal 10, game.frames[0].shots[0].score
    assert_nil game.frames[0].shots[1]
    assert_equal 1, game.frames[1].shots[0].score
  end

  # current_frame,previous_frame,second_previous_freameのテスト
  # 「1」を4回 add_shotしているので2フレームが埋まり、3フレーム目がcurrent_frameになっている
  def test_current_frame
    game = Game.new
    4.times do
      game.add_shot('1')
    end
    assert_equal 3, game.current_frame.frame_number
  end

  def test_previous_frame
    game = Game.new
    4.times do
      game.add_shot('1')
    end
    assert_equal 2, game.previous_frame.frame_number
  end

  def test_second_previous_frame
    game = Game.new
    4.times do
      game.add_shot('1')
    end
    assert_equal 1, game.second_previous_frame.frame_number
  end

  def test_update_bonus1
    game = Game.new
    game.add_shot('1')
    assert_nil game.frames[0].bonus
  end

  # total_scoreのテスト
  def test_total_score
    game = Game.new
    shot_data = '6,3,9,0,0,3,8,2,7,3,X,9,1,X,X,6,4,5'
    shot_symbols = shot_data.split(',')
    shot_symbols.each do |shot_symbol|
      game.add_shot(shot_symbol)
    end
    assert_equal 159, game.total_score
  end

  def test_total_score2
    game = Game.new
    shot_data = '6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,X,X'
    shot_symbols = shot_data.split(',')
    shot_symbols.each do |shot_symbol|
      game.add_shot(shot_symbol)
    end
    assert_equal 164, game.total_score
  end

  def test_total_score3
    game = Game.new
    shot_data = '0,10,1,5,0,0,0,0,X,X,X,5,1,8,1,0,4'
    shot_symbols = shot_data.split(',')
    shot_symbols.each do |shot_symbol|
      game.add_shot(shot_symbol)
    end
    assert_equal 107, game.total_score
  end

  def test_total_score4
    game = Game.new
    shot_data = '6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,0,0'
    shot_symbols = shot_data.split(',')
    shot_symbols.each do |shot_symbol|
      game.add_shot(shot_symbol)
    end
    assert_equal 134, game.total_score
  end

  def test_total_score5
    game = Game.new
    shot_data = '6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,1,8'
    shot_symbols = shot_data.split(',')
    shot_symbols.each do |shot_symbol|
      game.add_shot(shot_symbol)
    end
    assert_equal 144, game.total_score
  end

  def test_total_score6
    game = Game.new
    shot_data = 'X,X,X,X,X,X,X,X,X,X,X,X'
    shot_symbols = shot_data.split(',')
    shot_symbols.each do |shot_symbol|
      game.add_shot(shot_symbol)
    end
    assert_equal 300, game.total_score
  end

  def test_total_score7
    game = Game.new
    shot_data = 'X,0,0,X,0,0,X,0,0,X,0,0,X,0,0 '
    shot_symbols = shot_data.split(',')
    shot_symbols.each do |shot_symbol|
      game.add_shot(shot_symbol)
    end
    assert_equal 50, game.total_score
  end
end
