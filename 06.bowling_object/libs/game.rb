# frozen_string_literal: true

class Game
  attr_reader :frames

  def initialize(frames)
    @frames = frames.map { |frame| Frame.new(*frame) }
  end
end
