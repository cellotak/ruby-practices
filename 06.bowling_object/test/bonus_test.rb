# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../libs/bonus'

class BonusTest < Minitest::Test
  def test_bonus_new
    bonus = Bonus.new
    assert_equal nil, bonus.bonus_score
  end

  def test_pended
    bonus = Bonus.new
    assert bonus.pended? 
  end

  def test_not_pended
    bonus = Bonus.new
    bonus.bonus_score = 0
    refute bonus.pended?
  end

end
