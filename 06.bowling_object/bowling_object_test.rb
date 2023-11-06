# frozen_string_literal: true

require 'minitest/autorun'
require_relative './frame'
require_relative './game'
require_relative './shot'

class BowlingTest < Minitest::Test
  def test_shot_new
    shot = Shot.new('X')
    assert_equal 'X', shot.mark
  end

  def test_socore_when_mark_is_X
    shot = Shot.new('X')
    assert_equal 10, shot.score
  end
  
  def test_score_when_mark_is_not_X
    shot = Shot.new('1')
    assert_equal 1, shot.score
  end

  def test_frame_new
    frame = Frame.new('1','2','X')
    assert_equal '1', frame.first_shot.mark
    assert_equal '2', frame.second_shot.mark
    assert_equal 'X', frame.third_shot.mark
  end

  def test_game
    assert Game.new
  end

end

