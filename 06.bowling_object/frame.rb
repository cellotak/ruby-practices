class Frame
  attr_reader :shots

  def initialize
    @shots = []
  end

  def add_shot(char)
    shots << Shot.new(char)
  end

  def strike?
    shots[0].shot_score == 10
  end

  def spare?
    shots.map(&:shot_score).sum == 10
  end
end
