# frozen_string_literal: true

class Shot
  attr_reader :score

  ALL_PIN = 10

  def initialize(symbol)
    @score = symbol == 'X' ? ALL_PIN : symbol.to_i
  end
end
