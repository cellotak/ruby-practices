# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../libs/shot'

class ShotTest < Minitest::Test
  def test_shot_score_when_shot_symbol_is_x
    shot = Shot.new('X')
    assert_equal 10, shot.score
  end

  def test_shot_score_when_shot_symbol_is_not_x
    shot = Shot.new('1')
    assert_equal 1, shot.score
  end
end
