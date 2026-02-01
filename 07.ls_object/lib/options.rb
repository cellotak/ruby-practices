# frozen_string_literal: true

require 'optparse'
require_relative 'long_formatter'
require_relative 'default_formatter'

class Options
  attr_reader :paths

  def initialize(argv)
    @options = {}
    @paths = parse(argv)
  end

  def prepare_filenames(filenames)
    sorted_filenames = sort(filenames)
    select_visible_entries(sorted_filenames)
  end

  def sort(items)
    reverse? ? items.sort.reverse : items.sort
  end

  def select_visible_entries(items)
    all? ? items : items.reject { |item| item.start_with?('.') }
  end

  def formatter
    long_format? ? LongFormatter.new : DefaultFormatter.new
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
