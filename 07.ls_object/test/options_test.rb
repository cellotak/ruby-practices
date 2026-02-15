# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/options'
require_relative '../lib/long_formatter'
require_relative '../lib/grid_formatter'

class OptionsTest < Minitest::Test
  def test_formatter_default
    argv = []
    options = Options.new(argv)

    assert_instance_of GridFormatter, options.formatter
  end

  def test_formatter_long
    argv = ['-l']
    options = Options.new(argv)

    assert_instance_of LongFormatter, options.formatter
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

  def test_prepare_filenames_default
    argv = []
    options = Options.new(argv)
    items = %w[b .hidden a]

    assert_equal %w[a b], options.prepare_filenames(items)
  end

  def test_prepare_filenames_all_reverse
    argv = ['-a', '-r']
    options = Options.new(argv)
    items = %w[b .hidden a]

    assert_equal %w[b a .hidden], options.prepare_filenames(items)
  end

  def test_paths
    argv = ['-l', '/tmp', 'lib']
    options = Options.new(argv)

    assert_equal %w[/tmp lib], options.paths
  end
end
