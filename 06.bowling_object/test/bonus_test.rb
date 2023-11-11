# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../libs/bonus'

class BonusTest < Minitest::Test
  def test_bonus_new
    bonus = Bonus.new(10)
    assert_equal 10, bonus.bonus_score
  end
end
