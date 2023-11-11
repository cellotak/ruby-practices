class Bonus
  attr_accessor :bonus_score

  def pended?
    bonus_score.nil?
  end

end
