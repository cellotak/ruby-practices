# frozen_string_literal: true

require 'optparse'
require_relative 'long_format'
require_relative 'grid_format'

class Options
  attr_reader :paths

  def initialize(argv)
    @options = {}
    @paths = parse(argv)
  end

  def sort(items)
    sorted = items.sort_by(&:downcase)
    reverse? ? sorted.reverse : sorted
  end

  def select_visible_entries(items)
    all? ? items : items.reject { |item| item.start_with?('.') }
  end

  def format
    long_format? ? LongFormat.new : GridFormat.new
  end

  private

  def long_format?
    @options[:l]
  end

  def all?
    @options[:a]
  end

  def reverse?
    @options[:r]
  end

  def parse(argv)
    parser = OptionParser.new

    parser.on('-l') { |v| @options[:l] = v }
    parser.on('-a') { |v| @options[:a] = v }
    parser.on('-r') { |v| @options[:r] = v }

    parser.parse(argv)
  end
end
