# frozen_string_literal: true

class Shot
  attr_reader :score

  def initialize(symbol)
    @score = symbol == 'X' ? 10 : symbol.to_i
  end
end
