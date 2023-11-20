# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../libs/frame'

class FrameTest < Minitest::Test
  # initializeで@shots,@frame_nunber,@bonusが正しく初期化されているか
  def test_frame_initialize
    frame = Frame.new(1)
    assert_equal [], frame.shots
    assert_nil frame.bonus
    assert_equal 1, frame.frame_number
  end

  # add_shotのテスト
  # ストライクをadd_shotしたとき
  def test_add_shot_with_strike
    frame = Frame.new(1)
    frame.add_shot('X')
    assert_equal 10, frame.shots[0].score
  end

  # ストライクでないスコアをadd_shotしたとき
  def test_add_shot_with_not_strike
    frame = Frame.new(1)
    frame.add_shot('3')
    frame.add_shot('2')
    assert_equal 3, frame.shots[0].score
    assert_equal 2, frame.shots[1].score
  end

  # strike?、spare?、mark?、no_mark?のテスト
  # ストライクの時
  def test_strike_spare_mark_no_mark_with_strike
    frame = Frame.new(1)
    frame.add_shot('X')
    assert frame.strike?
    refute frame.spare?
    assert frame.mark?
    refute frame.no_mark?
  end

  # スペアの時
  def test_strike_spare_mark_no_mark_with_spare
    frame = Frame.new(1)
    frame.add_shot('0')
    frame.add_shot('X')
    refute frame.strike?
    assert frame.spare?
    assert frame.mark?
    refute frame.no_mark?
  end

  # ストライクでもスペアでもない(markでない)時
  def test_strike_spare_mark_no_mark_without_mark
    frame = Frame.new(1)
    frame.add_shot('1')
    frame.add_shot('2')
    refute frame.strike?
    refute frame.spare?
    refute frame.mark?
    assert frame.no_mark?
  end

  # bonus_pended?についてのテスト
  # ボーナスが保留中
  def test_bonus_pended?
    frame = Frame.new(1)
    assert frame.bonus_pended?
  end

  # ボーナス確定済み
  def test_bonus_not_pended?
    frame = Frame.new(1)
    frame.comfirm_bonus(10)
    refute frame.bonus_pended?
  end

  # bonus_scoreのテスト
  def test_bonus_score_when_bonus_is_ten
    frame = Frame.new(1)
    frame.comfirm_bonus(10)
    assert_equal 10, frame.bonus
  end

  # filled?のテスト
  # last_frameの時
  # 1投してストライクではないとき => false
  def test_filled_when_last_frame_not_filled_with_one_shot
    frame = Frame.new(10)
    frame.add_shot('1')
    refute frame.filled?
  end

  # 1投してストライクのとき => false
  def test_filled_when_last_frame_not_filled_with_strike
    frame = Frame.new(10)
    frame.add_shot('X')
    refute frame.filled?
  end

  # 2投して1投目ストライクの時 => false
  def test_filled_when_last_frame_not_filled_with_strike_and_one_shot
    frame = Frame.new(10)
    frame.add_shot('X')
    frame.add_shot('1')
    refute frame.filled?
  end

  # 2投してスペアの時 => false
  def test_filled_when_last_frame_not_filled_with_spare
    frame = Frame.new(10)
    frame.add_shot('6')
    frame.add_shot('4')
    refute frame.filled?
  end

  # 2投してストライクでもスペアでもないとき => true
  def test_filled_when_last_frame_filled_with_two_shot
    frame = Frame.new(10)
    frame.add_shot('1')
    frame.add_shot('2')
    assert frame.filled?
  end

  # 3投して1投目がストライクの時 => true
  def test_filled_when_last_frame_filled_with_strike_and_two_shot
    frame = Frame.new(10)
    frame.add_shot('X')
    frame.add_shot('X')
    frame.add_shot('X')
    assert frame.filled?
  end

  # 3投して1,2投目がスペアの時 => true
  def test_filled_when_last_frame_filled_with_spare_and_one_shot
    frame = Frame.new(10)
    frame.add_shot('6')
    frame.add_shot('4')
    frame.add_shot('1')
    assert frame.filled?
  end

  # 1～9frame
  # 1投して、ストライクではないとき => false
  def test_filled_when_frame_not_filled_with_one_shot
    frame = Frame.new(1)
    frame.add_shot('1')
    refute frame.filled?
  end

  # 1投してストライクのとき => true
  def test_filled_when_frame_filled_with_strike
    frame = Frame.new(1)
    frame.add_shot('X')
    assert frame.filled?
  end

  # 2投してスペアではないとき => true
  def test_filled_when_frame_filled_with_two_shot_and_not_spare
    frame = Frame.new(1)
    frame.add_shot('1')
    frame.add_shot('2')
    assert frame.filled?
  end

  # 2投してスペアのとき => true
  def test_filled_when_frame_filled_with_two_shot_and_spare
    frame = Frame.new(1)
    frame.add_shot('6')
    frame.add_shot('4')
    assert frame.filled?
  end

  # scoreのテスト
  def test_score_with_bonus
    frame = Frame.new(1)
    frame.add_shot('6')
    frame.add_shot('4')
    frame.comfirm_bonus(3)
    assert_equal 13, frame.score
  end

  def test_score_without_bonus
    frame = Frame.new(1)
    frame.add_shot('6')
    frame.add_shot('4')
    assert_nil frame.score
  end
end
