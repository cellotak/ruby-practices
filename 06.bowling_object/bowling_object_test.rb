# frozen_string_literal: true

require 'minitest/autorun'
require_relative './frame'
require_relative './game'
require_relative './shot'

class BowlingTest < Minitest::Test
  def test_frame
    assert Frame.new
  end

  def test_game
    assert Game.new
  end

  def test_shot
    shot = Shot.new('X')
    assert_equal 'X', shot.mark
  end
end
