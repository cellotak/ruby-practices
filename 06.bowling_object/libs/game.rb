# frozen_string_literal: true

class Game
  attr_reader :frames
  attr_accessor :current_frame_index

  def initialize
    @frames = []
    @current_frame_index = 0
    @frames << Frame.new
  end

  def add_shot(char)
    if current_frame_index < 9
      case current_frame.shots.size
      when 0
        current_frame.add_shot(char)
      when 1
        current_frame.add_shot(char)
        frames << Frame.new
        @current_frame_index += 1
      end
    end
  end

  def current_frame
    @frames[current_frame_index]
  end
end
