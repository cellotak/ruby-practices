class Shot 
  attr_reader :shot_char, :shot_score

  def initialize(char)
    @shot_char = char
    @shot_score = shot_char == 'X' ? 10 : shot_char.to_i
  end
end
