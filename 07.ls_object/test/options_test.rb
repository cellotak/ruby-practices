# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/options'
require_relative '../lib/long_format'
require_relative '../lib/grid_format'

class OptionsTest < Minitest::Test
  def test_format_default
    argv = []
    options = Options.new(argv)

    assert_instance_of GridFormat, options.format
  end

  def test_format_long
    argv = ['-l']
    options = Options.new(argv)

    assert_instance_of LongFormat, options.format
  end

  def test_sort_default
    argv = []
    options = Options.new(argv)
    items = %w[b a c]

    assert_equal %w[a b c], options.sort(items)
  end

  def test_sort_reverse
    argv = ['-r']
    options = Options.new(argv)
    items = %w[b a c]

    assert_equal %w[c b a], options.sort(items)
  end

  def test_select_visible_entries_default
    argv = []
    options = Options.new(argv)
    items = %w[file1 .hidden file2]

    assert_equal %w[file1 file2], options.select_visible_entries(items)
  end

  def test_select_visible_entries_all
    argv = ['-a']
    options = Options.new(argv)
    items = %w[file1 .hidden file2]

    assert_equal %w[file1 .hidden file2], options.select_visible_entries(items)
  end

  def test_paths
    argv = ['-l', '/tmp', 'lib']
    options = Options.new(argv)

    assert_equal %w[/tmp lib], options.paths
  end
end
