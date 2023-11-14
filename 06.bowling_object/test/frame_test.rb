# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../libs/frame'

class FrameTest < Minitest::Test
  def test_frame_new
    frame = Frame.new(1)
    assert_equal [], frame.shots
    assert_equal 1, frame.frame_number
  end

  def test_add_shot_with_strike
    frame = Frame.new(1)
    frame.add_shot('X')
    assert_equal 10, frame.shots[0].shot_score
  end

  def test_add_shot_with_not_strike
    frame = Frame.new(1)
    frame.add_shot('3')
    frame.add_shot('2')
    assert_equal 3, frame.shots[0].shot_score
    assert_equal 2, frame.shots[1].shot_score
  end

  # strike?やspare?のテスト
  # ストライクの時 strike?はtrue,spare?はfalse
  def test_strike
    frame = Frame.new(1)
    frame.add_shot('X')
    assert frame.strike?
    refute frame.spare?
  end

  def test_not_strike_and_spare_with_second_shot_is_x
    frame = Frame.new(1)
    frame.add_shot('0')
    frame.add_shot('X')
    refute frame.strike?
    assert frame.spare?
  end

  def test_not_strike_and_not_spare
    frame = Frame.new(1)
    frame.add_shot('1')
    frame.add_shot('2')
    refute frame.strike?
    refute frame.spare?
  end

  # ボーナスについてのテスト
  def test_bonus_pended?
    frame = Frame.new(1)
    assert frame.bonus_pended?
  end

  def test_bonus_not_pended?
    frame = Frame.new(1)
    frame.add_bonus(10)
    refute frame.bonus_pended?
  end

  def test_bonus_score
    frame = Frame.new(1)
    frame.add_bonus(10)
    assert_equal 10, frame.bonus.bonus_score
  end

  # completed?のテスト
  # last_frameの時
  # 1投もしていないとき => false
  def test_last_frame_not_completed_with_no_shot
    frame = Frame.new(10)
    refute frame.completed?
  end

  # 1投してストライクではないとき => false
  def test_last_frame_not_completed_with_one_shot
    frame = Frame.new(10)
    frame.add_shot('1')
    refute frame.completed?
  end

  # 2投してストライクでもスペアでもないとき => true
  def test_last_frame_completed_without_strike_or_spare
    frame = Frame.new(10)
    frame.add_shot('1')
    frame.add_shot('2')
    assert frame.completed?
  end

  # 1投してストライクのとき => false
  def test_last_frame_not_completed_with_strike
    frame = Frame.new(10)
    frame.add_shot('X')
    refute frame.completed?
  end

  # 1投目がストライクで2投した時 => false
  def test_last_frame_not_completed_with_strike_and_one_shot
    frame = Frame.new(10)
    frame.add_shot('X')
    frame.add_shot('1')
    refute frame.completed?
  end

  # 1投目がストライクで3投した時 => true
  def test_last_frame_completed_with_strike_and_two_shot
    frame = Frame.new(10)
    frame.add_shot('X')
    frame.add_shot('X')
    frame.add_shot('X')
    assert frame.completed?
  end

  # 2投してスペアの時 => false
  def test_last_frame_not_completed_with_spare
    frame = Frame.new(10)
    frame.add_shot('6')
    frame.add_shot('4')
    refute frame.completed?
  end

  # 2投してスペアでさらに1投した時 => true
  def test_last_frame_completed_with_spare_and_one_shot
    frame = Frame.new(10)
    frame.add_shot('6')
    frame.add_shot('4')
    frame.add_shot('1')
    assert frame.completed?
  end

  # 1～9frame
  # 1投もしていないとき => false
  def test_not_completed_with_no_shot
    frame = Frame.new(1)
    refute frame.completed?
  end

  # 1投だけして、ストライク出ないとき => false
  def test_frame_not_completed_with_one_shot
    frame = Frame.new(1)
    frame.add_shot('1')
    refute frame.completed?
  end

  # 2投してスペアでないとき
  def test_frame_complete_with_two_shot_and_not_spare
    frame = Frame.new(1)
    frame.add_shot('1')
    frame.add_shot('2')
    assert frame.completed?
  end

  # 2投してスペアのとき
  def test_frame_complete_with_two_shot_and_spare
    frame = Frame.new(1)
    frame.add_shot('6')
    frame.add_shot('4')
    assert frame.completed?
  end

  # 1投してストライクのとき
  def test_frame_complete_with_strike
    frame = Frame.new(1)
    frame.add_shot('X')
    assert frame.completed?
  end
end
