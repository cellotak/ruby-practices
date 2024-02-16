# frozen_string_literal: true

class Shot
  attr_reader :score

  ALL_PINS = 10

  def initialize(symbol)
    @score = symbol == 'X' ? ALL_PINS : symbol.to_i
  end
end
