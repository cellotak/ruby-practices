# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../libs/frame'

class FrameTest < Minitest::Test

  def test_frame_new
    frame = Frame.new
    assert_equal [], frame.shots
  end

  def test_add_shot_with_strike
    frame = Frame.new
    frame.add_shot('X')
    assert_equal 10, frame.shots[0].shot_score
  end

  def test_add_shot_with_not_strike
    frame = Frame.new
    frame.add_shot('3')
    frame.add_shot('2')
    assert_equal 3, frame.shots[0].shot_score
    assert_equal 2, frame.shots[1].shot_score
  end

  def test_strike?
    frame = Frame.new
    frame.add_shot('X')
    assert frame.strike?
  end
  
  def test_spare?
    frame = Frame.new
    frame.add_shot('6')
    frame.add_shot('4')
    assert frame.spare?
  end

  def test_bonus_pended?
    frame = Frame.new
    assert frame.bonus_pended?
  end

  def test_bonus_not_pended?
    frame = Frame.new
    frame.add_bonus(10)
    refute frame.bonus_pended?
  end

  def test_bonus_is_10
    frame = Frame.new
    frame.add_bonus(10)
    assert_equal 10, frame.bonus.bonus_score
  end
end
