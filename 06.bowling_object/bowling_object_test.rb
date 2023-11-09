# frozen_string_literal: true

require 'minitest/autorun'
require_relative './shot'
require_relative './frame'
require_relative './game'

class BowlingTest < Minitest::Test
  def test_shot_char_when_shot_char_is_X
    shot = Shot.new('X')
    assert_equal 'X', shot.shot_char
  end

  def test_shot_score_when_shot_char_is_X
    shot = Shot.new('X')
    assert_equal 10, shot.shot_score
  end
  
  # def test_score_when_mark_is_not_X
  #   shot = Shot.new('1')
  #   assert_equal 1, shot.score
  # end

  # def test_frame_new
  #   frame = Frame.new('1','2','X')
  #   assert_equal '1', frame.first_shot.mark
  #   assert_equal '2', frame.second_shot.mark
  #   assert_equal 'X', frame.third_shot.mark
  # end

  # def test_frame_score
  #   frame = Frame.new('1','2')
  #   assert_equal 3, frame.score
  # end

  # def test_game_new
  #   frames = [['1','2'],['3','4']]
  #   game = Game.new(frames)
  #   assert_equal 3, game.frames[0].score
  #   assert_equal 7, game.frames[1].score
  # end

end

