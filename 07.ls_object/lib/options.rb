# frozen_string_literal: true

require 'optparse'

class Options
  attr_reader :paths

  def initialize(argv)
    @options = {}
    @paths = parse(argv)
  end

  def long_format?
    @options[:l]
  end

  def all?
    @options[:a]
  end

  def reverse?
    @options[:r]
  end

  private

  def parse(argv)
    parser = OptionParser.new

    parser.on('-l') { |v| @options[:l] = v }
    parser.on('-a') { |v| @options[:a] = v }
    parser.on('-r') { |v| @options[:r] = v }

    parser.parse(argv)
  end
end
