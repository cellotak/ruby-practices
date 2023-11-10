# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../libs/shot'


class ShotTest < Minitest::Test
  def test_shot_char_when_shot_char_is_X
    shot = Shot.new('X')
    assert_equal 'X', shot.shot_char
  end

  def test_shot_score_when_shot_char_is_X
    shot = Shot.new('X')
    assert_equal 10, shot.shot_score
  end

  def test_shot_score_when_shot_char_is_not_X
    shot = Shot.new('1')
    assert_equal 1, shot.shot_score
  end
end
