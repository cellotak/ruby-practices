# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../wc'

class ParseOptionsTest < Minitest::Test
  def test_with_l_option
    options, file_paths = parse_options(['-l'])
    assert_equal({ l: true }, options)
    assert_equal([], file_paths)
  end

  def test_with_w_option
    options, file_paths = parse_options(['-w'])
    assert_equal({ w: true }, options)
    assert_equal([], file_paths)
  end

  def test_with_c_option
    options, file_paths = parse_options(['-c'])
    assert_equal({ c: true }, options)
    assert_equal([], file_paths)
  end

  def test_with_multiple_options
    options, file_paths = parse_options(['-l', '-w', '-c'])
    assert_equal({ l: true, w: true, c: true }, options)
    assert_equal([], file_paths)
  end

  def test_with_file_paths
    options, file_paths = parse_options(['file1.txt', 'file2.txt'])
    assert_equal({}, options)
    assert_equal(['file1.txt', 'file2.txt'], file_paths)
  end

  def test_with_options_and_file_paths
    options, file_paths = parse_options(['-l', '-w', 'file1.txt', 'file2.txt'])
    assert_equal({ l: true, w: true }, options)
    assert_equal(['file1.txt', 'file2.txt'], file_paths)
  end
end
