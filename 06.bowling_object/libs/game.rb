# frozen_string_literal: true

require_relative '../libs/frame'

class Game
  attr_reader :frames

  def initialize
    @frames = []
    @frames << Frame.new
  end

  def add_shot(char)
    if current_frame.completed?
      frames << Frame.new
      current_frame.add_shot(char)
    else
      current_frame.add_shot(char)
    end
  end

  def current_frame
    @frames.last
  end
end
