# frozen_string_literal: true

require_relative '../libs/entry'

class NonChildFileEntry < Entry
  attr_reader :specified_path

  def initialize(specified_path)
    @basename = File.basename(specified_path)
    @dirname = File.dirname(specified_path)
    @stat = File::Stat.new(specified_path)
    @specified_path = specified_path
  end

  def path
    specified_path
  end
end
