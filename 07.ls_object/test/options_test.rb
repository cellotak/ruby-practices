# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/options'

class OptionsTest < Minitest::Test
  def test_parse_long_format
    argv = ['-l']
    options = Options.new(argv)
    assert options.long_format?
  end

  def test_parse_all
    argv = ['-a']
    options = Options.new(argv)
    assert options.all?
  end

  def test_parse_reverse
    argv = ['-r']
    options = Options.new(argv)
    assert options.reverse?
  end

  def test_parse_paths
    argv = ['/tmp', 'lib']
    options = Options.new(argv)

    assert_equal ['/tmp', 'lib'], options.paths
  end

  def test_parse_mixed
    argv = ['-l', '/etc', '-a']
    options = Options.new(argv)

    assert options.long_format?
    assert options.all?
    assert_equal ['/etc'], options.paths
  end

  def test_no_paths
    argv = ['-l']
    options = Options.new(argv)
    assert_empty options.paths
  end
end
